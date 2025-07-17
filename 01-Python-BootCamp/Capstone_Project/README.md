# FTP File Transfer System - Capstone Project

A complete FTP (File Transfer Protocol) client-server application built with Python for transferring files between local and remote systems.

## Features

### FTP Server
- Anonymous FTP server with full read/write permissions
- Serves files from the `Storage/` directory
- Clean command-line interface
- Graceful shutdown with Ctrl+C
- Automatic connection handling

### FTP Client (GUI)
- Modern graphical user interface built with tkinter
- File upload and download capabilities
- Directory navigation with double-click
- Batch download functionality
- Real-time activity logging
- Visual file browser with icons

## Project Structure

```
Python/Capstone_Project/
├── client.py          # GUI FTP client application
├── server.py          # Command-line FTP server
├── Storage/           # Server storage directory
│   ├── documents/     # Sample documents folder
│   └── images/        # Sample images folder
├── Client_storage/    # Client download directory (auto-created)
├── requirements.txt   # Python dependencies
└── README.md         # This file
```

## Installation

1. **Clone or download the project files**

2. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Verify Python version:**
   - Python 3.6 or higher required
   - tkinter is included with most Python installations

## Usage

### Starting the FTP Server

1. **Run the server:**
   ```bash
   python server.py
   ```

2. **Server output:**
   ```
   Starting FTP server on 127.0.0.1:21
   Press Ctrl+C to shutdown the server
   Server is listening on 127.0.0.1:21
   Anonymous access enabled with path: Storage/
   Server is ready to accept connections
   ```

3. **Shutdown the server:**
   - Press `Ctrl+C` to stop the server gracefully

### Using the FTP Client

1. **Run the client:**
   ```bash
   python client.py
   ```

2. **Connect to server:**
   - Enter server host (default: 127.0.0.1)
   - Click "Connect" button

3. **File operations:**
   - **Upload files:** Click "Upload File" and select a file
   - **Download files:** Select a file and click "Download File"
   - **Download all:** Click "Download All" to download all files in current directory
   - **Navigate directories:** Double-click on folder icons
   - **Go up:** Click "Go Up" button to navigate to parent directory
   - **Create directories:** Click "Create Directory" and enter name
   - **Refresh:** Click "Refresh" to update file listing

## Key Features

### Client Features
- **Automatic Storage:** All downloads saved to `Client_storage/` folder
- **Original Filenames:** Files maintain their original names
- **Directory Navigation:** Easy browsing with visual icons
- **Activity Log:** Real-time logging of all operations
- **Error Handling:** User-friendly error messages
- **Connection Status:** Visual connection indicators

### Server Features
- **Anonymous Access:** No authentication required for testing
- **Full Permissions:** Read, write, delete, and modify permissions
- **Storage Directory:** Serves files from `Storage/` folder
- **Clean Shutdown:** Proper connection cleanup on exit
- **Error Handling:** Robust error handling and logging

## File Transfer Process

1. **Server Setup:**
   - Start the FTP server on localhost:21
   - Server serves files from `Storage/` directory

2. **Client Connection:**
   - Client connects to server using FTP protocol
   - GUI displays server file structure

3. **File Operations:**
   - Upload: Files transferred from client to server
   - Download: Files transferred from server to `Client_storage/`
   - Navigation: Browse server directories in real-time

## Technical Details

### Dependencies
- **pyftpdlib:** Python FTP server library
- **tkinter:** GUI framework (built-in with Python)
- **threading:** For non-blocking operations
- **os:** File system operations

### Network Configuration
- **Host:** 127.0.0.1 (localhost)
- **Port:** 21 (standard FTP port)
- **Protocol:** FTP (File Transfer Protocol)
- **Authentication:** Anonymous access

### File Storage
- **Server Storage:** `Storage/` directory
- **Client Downloads:** `Client_storage/` directory (auto-created)
- **File Preservation:** Original filenames and structure maintained

## Sample Data

The project includes sample files in the `Storage/` directory:
- **documents/:** Text files and documents
- **images/:** Various image formats (PNG, JPG)

## Troubleshooting

### Common Issues

1. **Port 21 already in use:**
   - Stop any existing FTP servers
   - Check for other applications using port 21

2. **Permission errors:**
   - Ensure write permissions in project directory
   - Run with appropriate user privileges

3. **Connection refused:**
   - Verify server is running
   - Check firewall settings
   - Confirm correct host address

4. **Directory navigation errors:**
   - Use "Refresh" button to update file listing
   - Check server permissions
   - Verify directory exists on server

### Error Messages
- **"550 No such file or directory":** Directory doesn't exist
- **"Connection refused":** Server not running or blocked
- **"Permission denied":** Insufficient file permissions

## Development Notes

- **Client:** GUI application with event-driven architecture
- **Server:** Multi-threaded server handling concurrent connections
- **Protocol:** Standard FTP implementation
- **Error Handling:** Comprehensive exception handling throughout
- **Threading:** Non-blocking operations for better user experience

## Future Enhancements

Potential improvements for the system:
- User authentication and access control
- SSL/TLS encryption for secure transfers
- Progress bars for large file transfers
- Resume capability for interrupted transfers
- Configuration file for server settings
- Logging to files for audit trails

## License

This project is created for educational purposes as part of a capstone project.

## Author

Capstone Project - FTP File Transfer System
