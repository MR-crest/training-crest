from pyftpdlib.authorizers import DummyAuthorizer
from pyftpdlib.handlers import FTPHandler
from pyftpdlib.servers import FTPServer
import signal
import sys


def signal_handler(_, __):
    print("\nShutting down FTP server...")
    if hasattr(signal_handler, "server"):
        signal_handler.server.close_all()
    print("Server shutdown complete.")
    sys.exit(0)


def start_server():
    try:
        print("Starting FTP server on 127.0.0.1:21")
        print("Press Ctrl+C to shutdown the server")

        authorizer = DummyAuthorizer()
        authorizer.add_anonymous("Storage/", perm="elradfmw")

        handler = FTPHandler
        handler.authorizer = authorizer
        address = ("127.0.0.1", 21)

        server = FTPServer(address, handler)

        signal_handler.server = server

        print(f"Server is listening on {address[0]}:{address[1]}")
        print(f"Anonymous access enabled with path: Storage/")
        print("Server is ready to accept connections")

        server.serve_forever()

    except KeyboardInterrupt:
        pass
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)


if __name__ == '__main__':
    signal.signal(signal.SIGINT, signal_handler)

    start_server()