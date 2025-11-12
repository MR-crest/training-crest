# accounts.py

from dataclasses import dataclass, asdict
from datetime import datetime
from typing import List, Dict, Any


@dataclass
class Transaction:
    """Record of a single account transaction."""
    type: str                     # deposit, withdrawal, buy, sell
    amount: float = 0.0           # cash amount for deposit/withdrawal
    symbol: str = ""              # ticker symbol for buy/sell
    quantity: int = 0             # number of shares for buy/sell
    price: float = 0.0            # share price at execution for buy/sell
    timestamp: datetime = datetime.utcnow()

    def to_dict(self) -> Dict[str, Any]:
        """Return a plain dict representation, suitable for external use."""
        data = asdict(self)
        # Convert datetime to ISO string for easier serialization
        data["timestamp"] = data["timestamp"].isoformat()
        # Remove empty fields for clarity
        return {k: v for k, v in data.items() if v not in ("", 0, 0.0)}


def get_share_price(symbol: str) -> float:
    """
    Returns the current price of a share.

    Args:
        symbol (str): The symbol of the share.

    Returns:
        float: The current price of the share. Returns 0.0 for unknown symbols.
    """
    # Test implementation with fixed prices
    prices = {
        "AAPL": 100.0,
        "TSLA": 500.0,
        "GOOGL": 2000.0,
    }
    return prices.get(symbol.upper(), 0.0)


class Account:
    """
    Simple account management for a trading simulation platform.
    """

    def __init__(self, initial_deposit: float):
        """
        Initialize a new account.

        Args:
            initial_deposit (float): Starting cash balance.
        """
        if initial_deposit < 0:
            raise ValueError("Initial deposit cannot be negative")
        self.initial_deposit: float = initial_deposit
        self.balance: float = initial_deposit
        self.holdings: Dict[str, int] = {}          # symbol -> quantity
        self._transactions: List[Transaction] = []

        # Record the opening deposit as a transaction for completeness
        self._record_transaction(Transaction(type="deposit", amount=initial_deposit))

    # --------------------------------------------------------------------- #
    # Internal helpers
    # --------------------------------------------------------------------- #
    def _record_transaction(self, txn: Transaction) -> None:
        """Append a transaction to the internal log."""
        self._transactions.append(txn)

    # --------------------------------------------------------------------- #
    # Public API
    # --------------------------------------------------------------------- #
    def deposit(self, amount: float) -> None:
        """Add cash to the account."""
        if amount <= 0:
            raise ValueError("Deposit amount must be positive")
        self.balance += amount
        self._record_transaction(Transaction(type="deposit", amount=amount))

    def withdraw(self, amount: float) -> None:
        """Remove cash from the account, ensuring non‑negative balance."""
        if amount <= 0:
            raise ValueError("Withdrawal amount must be positive")
        if amount > self.balance:
            raise ValueError("Insufficient balance for withdrawal")
        self.balance -= amount
        self._record_transaction(Transaction(type="withdrawal", amount=amount))

    def buy_share(self, symbol: str, quantity: int) -> None:
        """
        Purchase shares.

        Args:
            symbol (str): Ticker symbol.
            quantity (int): Number of shares to buy.

        Raises:
            ValueError: If insufficient cash or invalid parameters.
        """
        symbol = symbol.upper()
        if quantity <= 0:
            raise ValueError("Quantity to buy must be positive")
        price = get_share_price(symbol)
        if price == 0.0:
            raise ValueError(f"Unknown share symbol: {symbol}")
        total_cost = price * quantity
        if total_cost > self.balance:
            raise ValueError("Insufficient balance to buy shares")
        self.balance -= total_cost
        self.holdings[symbol] = self.holdings.get(symbol, 0) + quantity
        self._record_transaction(
            Transaction(type="buy", symbol=symbol, quantity=quantity, price=price, amount=total_cost)
        )

    def sell_share(self, symbol: str, quantity: int) -> None:
        """
        Sell shares.

        Args:
            symbol (str): Ticker symbol.
            quantity (int): Number of shares to sell.

        Raises:
            ValueError: If insufficient holdings or invalid parameters.
        """
        symbol = symbol.upper()
        if quantity <= 0:
            raise ValueError("Quantity to sell must be positive")
        if self.holdings.get(symbol, 0) < quantity:
            raise ValueError("Insufficient shares to sell")
        price = get_share_price(symbol)
        if price == 0.0:
            raise ValueError(f"Unknown share symbol: {symbol}")
        revenue = price * quantity
        self.balance += revenue
        new_qty = self.holdings[symbol] - quantity
        if new_qty:
            self.holdings[symbol] = new_qty
        else:
            del self.holdings[symbol]
        self._record_transaction(
            Transaction(type="sell", symbol=symbol, quantity=quantity, price=price, amount=revenue)
        )

    # --------------------------------------------------------------------- #
    # Reporting utilities
    # --------------------------------------------------------------------- #
    def get_balance(self) -> float:
        """Current cash balance."""
        return self.balance

    def get_holdings(self) -> Dict[str, int]:
        """Current share holdings (symbol -> quantity)."""
        # Return a copy to avoid external mutation
        return dict(self.holdings)

    def get_portfolio_value(self) -> float:
        """Market value of all held shares."""
        total = 0.0
        for symbol, qty in self.holdings.items():
            total += get_share_price(symbol) * qty
        return total

    def get_total_equity(self) -> float:
        """Cash + portfolio market value."""
        return self.balance + self.get_portfolio_value()

    def get_profit_loss(self) -> float:
        """
        Profit/Loss relative to the initial deposit.

        Returns:
            float: Positive for profit, negative for loss.
        """
        return self.get_total_equity() - self.initial_deposit

    def get_transactions(self) -> List[Dict[str, Any]]:
        """
        List all recorded transactions in chronological order.

        Returns:
            List[Dict]: Each transaction represented as a dictionary.
        """
        return [txn.to_dict() for txn in self._transactions]