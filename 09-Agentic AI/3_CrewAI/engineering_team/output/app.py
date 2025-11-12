import gradio as gr
from accounts import Account, get_share_price

# Global account instance
account = None

# --------------------------------------------------------------------- #
# Backend wrappers for UI interactions
# --------------------------------------------------------------------- #
def create_account(amount: float):
    global account
    if account is not None:
        return "Account already exists.", get_status()
    try:
        account = Account(amount)
        return f"Account created with initial deposit ${amount:.2f}", get_status()
    except Exception as e:
        return str(e), get_status()

def deposit_wrapper(amount: float):
    if account is None:
        return "No account exists.", get_status()
    try:
        account.deposit(amount)
        return f"Deposited ${amount:.2f}", get_status()
    except Exception as e:
        return str(e), get_status()

def withdraw_wrapper(amount: float):
    if account is None:
        return "No account exists.", get_status()
    try:
        account.withdraw(amount)
        return f"Withdrew ${amount:.2f}", get_status()
    except Exception as e:
        return str(e), get_status()

def buy_wrapper(symbol: str, quantity: int):
    if account is None:
        return "No account exists.", get_status()
    try:
        account.buy_share(symbol, quantity)
        return f"Bought {quantity} shares of {symbol.upper()}", get_status()
    except Exception as e:
        return str(e), get_status()

def sell_wrapper(symbol: str, quantity: int):
    if account is None:
        return "No account exists.", get_status()
    try:
        account.sell_share(symbol, quantity)
        return f"Sold {quantity} shares of {symbol.upper()}", get_status()
    except Exception as e:
        return str(e), get_status()

def refresh_status():
    return get_status()

def get_status():
    if account is None:
        return "No account has been created yet."
    bal = account.get_balance()
    holdings = account.get_holdings()
    portfolio = account.get_portfolio_value()
    equity = account.get_total_equity()
    pl = account.get_profit_loss()
    txns = account.get_transactions()

    status = (
        f"**Cash Balance:** ${bal:.2f}\n"
        f"**Portfolio Value:** ${portfolio:.2f}\n"
        f"**Total Equity:** ${equity:.2f}\n"
        f"**Profit / Loss:** ${pl:.2f}\n"
        f"**Holdings:** {holdings}\n\n"
        f"**Transactions:**\n"
    )
    if txns:
        lines = []
        for t in txns:
            ts = t.get("timestamp", "")
            typ = t.get("type", "").capitalize()
            amt = t.get("amount", "")
            sym = t.get("symbol", "")
            qty = t.get("quantity", "")
            lines.append(f"{ts} | {typ} | {sym} | Qty: {qty} | Amount: {amt}")
        status += "\n".join(lines)
    else:
        status += "No transactions recorded."
    return status

# --------------------------------------------------------------------- #
# Gradio UI
# --------------------------------------------------------------------- #
with gr.Blocks() as demo:
    gr.Markdown("## Trading Simulation Demo\n")
    
    # Account creation section
    with gr.Row():
        init_amount = gr.Number(label="Initial Deposit", value=1000.0, precision=2)
        create_btn = gr.Button("Create Account")
        status_output = gr.Markdown(label="Account Status", value=get_status())
    
    create_btn.click(create_account, inputs=init_amount, outputs=[status_output])
    
    # Deposit tab
    with gr.Tab("Deposit"):
        deposit_amount = gr.Number(label="Deposit Amount", precision=2)
        deposit_btn = gr.Button("Deposit")
        deposit_msg = gr.Textbox(label="Result", interactive=False)
        deposit_btn.click(deposit_wrapper, inputs=deposit_amount, outputs=[deposit_msg, status_output])
    
    # Withdrawal tab
    with gr.Tab("Withdraw"):
        withdraw_amount = gr.Number(label="Withdrawal Amount", precision=2)
        withdraw_btn = gr.Button("Withdraw")
        withdraw_msg = gr.Textbox(label="Result", interactive=False)
        withdraw_btn.click(withdraw_wrapper, inputs=withdraw_amount, outputs=[withdraw_msg, status_output])
    
    # Trade tab
    with gr.Tab("Trade"):
        trade_symbol = gr.Dropdown(choices=["AAPL", "TSLA", "GOOGL"], label="Symbol")
        trade_qty = gr.Number(label="Quantity", precision=0)
        buy_btn = gr.Button("Buy Shares")
        sell_btn = gr.Button("Sell Shares")
        trade_msg = gr.Textbox(label="Result", interactive=False)
        buy_btn.click(buy_wrapper, inputs=[trade_symbol, trade_qty], outputs=[trade_msg, status_output])
        sell_btn.click(sell_wrapper, inputs=[trade_symbol, trade_qty], outputs=[trade_msg, status_output])
    
    # Refresh status
    refresh_btn = gr.Button("Refresh Status")
    refresh_btn.click(refresh_status, outputs=status_output)

demo.launch()