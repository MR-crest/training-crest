from ftplib import FTP
import os
import tkinter as tk
from tkinter import ttk, filedialog, messagebox, scrolledtext, simpledialog
import threading


class FTPClient:
    def __init__(self):
        self.ftp = FTP()
        self.host = "127.0.0.1"
        self.port = 21
        self.current_dir = "/"
        self.connected = False

        self.root = tk.Tk()
        self.root.title("FTP Client - Capstone Project")
        self.root.geometry("800x600")
        self.root.configure(bg="#f0f0f0")

        self.setup_ui()

    def setup_ui(self):
        main_frame = ttk.Frame(self.root, padding="10")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))

        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)
        main_frame.columnconfigure(1, weight=1)
        main_frame.rowconfigure(4, weight=1)

        ttk.Label(main_frame, text="FTP Server Connection", font=("Arial", 14, "bold")).grid(row=0, column=0, columnspan=3, pady=(0, 10))

        ttk.Label(main_frame, text="Host:").grid(row=1, column=0, sticky=tk.W, padx=(0, 5))
        self.host_entry = ttk.Entry(main_frame, width=20)
        self.host_entry.insert(0, "127.0.0.1")
        self.host_entry.grid(row=1, column=1, sticky=(tk.W, tk.E), padx=(0, 10))

        self.connect_btn = ttk.Button(main_frame, text="Connect", command=self.connect)
        self.connect_btn.grid(row=1, column=2)

        self.status_label = ttk.Label(main_frame, text="Status: Not connected", foreground="red")
        self.status_label.grid(row=2, column=0, columnspan=3, pady=(5, 10))

        button_frame = ttk.Frame(main_frame)
        button_frame.grid(row=3, column=0, columnspan=3, pady=(0, 10), sticky=(tk.W, tk.E))

        ttk.Button(button_frame, text="Upload File", command=self.upload_file).pack(side=tk.LEFT, padx=(0, 5))
        ttk.Button(button_frame, text="Download File", command=self.download_file).pack(side=tk.LEFT, padx=(0, 5))
        ttk.Button(button_frame, text="Download All", command=self.download_all_files).pack(side=tk.LEFT, padx=(0, 5))
        ttk.Button(button_frame, text="Create Directory", command=self.create_directory).pack(side=tk.LEFT, padx=(0, 5))
        ttk.Button(button_frame, text="Go Up", command=self.go_up_directory).pack(side=tk.LEFT, padx=(0, 5))
        ttk.Button(button_frame, text="Refresh", command=self.refresh_files).pack(side=tk.LEFT)

        files_frame = ttk.LabelFrame(main_frame, text="Server Files", padding="5")
        files_frame.grid(row=4, column=0, columnspan=3, sticky=(tk.W, tk.E, tk.N, tk.S), pady=(0, 10))
        files_frame.columnconfigure(0, weight=1)
        files_frame.rowconfigure(1, weight=1)

        self.current_dir_label = ttk.Label(files_frame, text="Current Directory: /")
        self.current_dir_label.grid(row=0, column=0, sticky=tk.W, pady=(0, 5))

        self.file_tree = ttk.Treeview(files_frame, columns=("Type", "Size"), show="tree headings")
        self.file_tree.heading("#0", text="Name")
        self.file_tree.heading("Type", text="Type")
        self.file_tree.heading("Size", text="Size")
        self.file_tree.column("#0", width=300)
        self.file_tree.column("Type", width=100)
        self.file_tree.column("Size", width=100)
        self.file_tree.grid(row=1, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        self.file_tree.bind("<Double-1>", self.on_item_double_click)

        scrollbar = ttk.Scrollbar(files_frame, orient=tk.VERTICAL, command=self.file_tree.yview)
        scrollbar.grid(row=1, column=1, sticky=(tk.N, tk.S))
        self.file_tree.configure(yscrollcommand=scrollbar.set)

        log_frame = ttk.LabelFrame(main_frame, text="Activity Log", padding="5")
        log_frame.grid(row=5, column=0, columnspan=3, sticky=(tk.W, tk.E, tk.N, tk.S))
        log_frame.columnconfigure(0, weight=1)
        log_frame.rowconfigure(0, weight=1)

        self.log_text = scrolledtext.ScrolledText(log_frame, height=8, state=tk.DISABLED)
        self.log_text.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))

        main_frame.rowconfigure(5, weight=1)

    def log_message(self, message):
        self.log_text.config(state=tk.NORMAL)
        self.log_text.insert(tk.END, f"{message}\n")
        self.log_text.see(tk.END)
        self.log_text.config(state=tk.DISABLED)

    def connect(self):
        self.host = self.host_entry.get()
        try:
            self.ftp.connect(self.host, self.port)
            self.ftp.login()
            self.current_dir = self.ftp.pwd()
            self.connected = True
            self.status_label.config(text=f"Status: Connected to {self.host}", foreground="green")
            self.current_dir_label.config(text=f"Current Directory: {self.current_dir}")
            self.log_message(f"Connected to FTP server at {self.host}:{self.port}")
            self.refresh_files()
            self.connect_btn.config(text="Disconnect", command=self.disconnect)
        except Exception as e:
            messagebox.showerror("Connection Error", f"Failed to connect: {e}")
            self.log_message(f"Connection failed: {e}")

    def disconnect(self):
        try:
            self.ftp.quit()
            self.connected = False
            self.status_label.config(text="Status: Not connected", foreground="red")
            self.current_dir_label.config(text="Current Directory: /")
            self.file_tree.delete(*self.file_tree.get_children())
            self.log_message("Disconnected from FTP server")
            self.connect_btn.config(text="Connect", command=self.connect)
        except:
            pass

    def refresh_files(self):
        if not self.connected:
            return
        self.file_tree.delete(*self.file_tree.get_children())
        try:
            file_list = []
            self.ftp.retrlines("LIST", file_list.append)

            for item in file_list:
                parts = item.split(None, 8)
                if len(parts) >= 9:
                    permissions = parts[0]
                    file_type = "Directory" if permissions.startswith("d") else "File"
                    size = parts[4] if file_type == "File" else "-"
                    name = parts[8]

                    icon = "🗂️ " if file_type == "Directory" else "📄 "
                    self.file_tree.insert("", tk.END, text=f"{icon}{name}", values=(file_type, size))

            self.log_message(f"Refreshed file list for {self.current_dir}")
        except Exception as e:
            messagebox.showerror("Error", f"Error listing files: {e}")
            self.log_message(f"Error listing files: {e}")

    def on_item_double_click(self, _):
        if not self.connected:
            return
        item = self.file_tree.selection()[0]
        item_text = self.file_tree.item(item, "text")
        item_type = self.file_tree.item(item, "values")[0]

        name = item_text[2:].strip()

        if item_type == "Directory":
            self.change_directory(name)

    def change_directory(self, directory_name):
        if not self.connected:
            return

        try:
            self.ftp.cwd(directory_name)
            self.current_dir = self.ftp.pwd()
            self.current_dir_label.config(text=f"Current Directory: {self.current_dir}")
            self.refresh_files()
            self.log_message(f"Changed to directory: {self.current_dir}")
        except Exception as e:
            messagebox.showerror("Error", f"Error changing directory: {e}")
            self.log_message(f"Error changing directory: {e}")

    def go_up_directory(self):
        if not self.connected:
            return

        try:
            self.ftp.cwd("..")
            self.current_dir = self.ftp.pwd()
            self.current_dir_label.config(text=f"Current Directory: {self.current_dir}")
            self.refresh_files()
            self.log_message(f"Changed to parent directory: {self.current_dir}")
        except Exception as e:
            messagebox.showerror("Error", f"Error navigating to parent directory: {e}")
            self.log_message(f"Error navigating to parent directory: {e}")

    def upload_file(self):
        if not self.connected:
            messagebox.showwarning("Not Connected", "Please connect to the server first")
            return
        filename = filedialog.askopenfilename(title="Select File to Upload")
        if not filename:
            return
        try:
            with open(filename, "rb") as file:
                self.ftp.storbinary(f"STOR {os.path.basename(filename)}", file)
            self.log_message(f"File {filename} uploaded successfully to {self.current_dir}")
            self.refresh_files()
            messagebox.showinfo("Success", f"File uploaded successfully to {self.current_dir}")
        except Exception as e:
            messagebox.showerror("Error", f"Error uploading file: {e}")
            self.log_message(f"Error uploading file: {e}")

    def download_file(self):
        if not self.connected:
            messagebox.showwarning("Not Connected", "Please connect to the server first")
            return
        selected = self.file_tree.selection()
        if not selected:
            messagebox.showwarning("No Selection", "Please select a file to download")
            return
        item = selected[0]
        item_text = self.file_tree.item(item, "text")
        item_type = self.file_tree.item(item, "values")[0]
        if item_type != "File":
            messagebox.showwarning("Not a File", "You can only download files, not directories")
            return
        remote_filename = item_text[2:]
        local_directory = "Client_storage"
        local_path = os.path.join(local_directory, remote_filename)
        try:
            os.makedirs(local_directory, exist_ok=True)
            with open(local_path, "wb") as file:
                self.ftp.retrbinary(f"RETR {remote_filename}", file.write)
            self.log_message(f"{remote_filename} downloaded successfully to {local_path}")
            messagebox.showinfo("Success", f"File downloaded to {local_path}")
        except Exception as e:
            messagebox.showerror("Error", f"Error downloading file: {e}")
            self.log_message(f"Error downloading {remote_filename}: {e}")

    def download_all_files(self):
        if not self.connected:
            messagebox.showwarning("Not Connected", "Please connect to the server first")
            return
        local_directory = "Client_storage"
        def download_thread():
            try:
                os.makedirs(local_directory, exist_ok=True)
                file_list = []
                self.ftp.retrlines("LIST", file_list.append)
                downloaded_count = 0
                self.log_message(f"Downloading all files from {self.current_dir} to {local_directory}...")
                for item in file_list:
                    parts = item.split()
                    if len(parts) >= 9 and not parts[0].startswith("d"):
                        filename = " ".join(parts[8:])
                        local_path = os.path.join(local_directory, filename)
                        try:
                            with open(local_path, "wb") as file:
                                self.ftp.retrbinary(f"RETR {filename}", file.write)
                            self.log_message(f"Downloaded: {filename}")
                            downloaded_count += 1
                        except Exception as e:
                            self.log_message(f"Error downloading {filename}: {e}")
                self.log_message(f"Download complete! {downloaded_count} files downloaded to {local_directory}")
                messagebox.showinfo("Download Complete", f"{downloaded_count} files downloaded to {local_directory}")
            except Exception as e:
                messagebox.showerror("Error", f"Error downloading files: {e}")
                self.log_message(f"Error downloading files: {e}")
        thread = threading.Thread(target=download_thread)
        thread.daemon = True
        thread.start()

    def create_directory(self):
        if not self.connected:
            messagebox.showwarning("Not Connected", "Please connect to the server first")
            return
        dir_name = simpledialog.askstring("Create Directory", "Enter name for new directory:")
        if not dir_name:
            return
        try:
            self.ftp.mkd(dir_name)
            self.log_message(f"Directory '{dir_name}' created successfully")
            self.refresh_files()
            messagebox.showinfo("Success", f"Directory '{dir_name}' created successfully")
        except Exception as e:
            messagebox.showerror("Error", f"Error creating directory: {e}")
            self.log_message(f"Error creating directory: {e}")

    def run(self):
        self.root.mainloop()


if __name__ == "__main__":
    client = FTPClient()
    client.run()