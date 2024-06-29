Sure! Let's create a basic project that demonstrates encryption and decryption using symmetric cryptography. We'll build a simple command-line tool that allows users to encrypt and decrypt messages using a secret key.

Project: Message Encryptor

Prerequisites:
- Python 3.x installed

Step 1: Create a new Python file named `message_encryptor.py`.

Step 2: Install the required cryptography library:
```
pip install cryptography
```

Step 3: Implement the encryption and decryption functions:
```python
from cryptography.fernet import Fernet

def generate_key():
    """Generate a random encryption key."""
    return Fernet.generate_key()

def encrypt_message(message, key):
    """Encrypt the given message using the provided key."""
    f = Fernet(key)
    encrypted_message = f.encrypt(message.encode())
    return encrypted_message

def decrypt_message(encrypted_message, key):
    """Decrypt the given encrypted message using the provided key."""
    f = Fernet(key)
    decrypted_message = f.decrypt(encrypted_message).decode()
    return decrypted_message
```

Step 4: Implement the main function to handle user input and perform encryption and decryption:
```python
def main():
    print("Welcome to Message Encryptor!")

    while True:
        print("\nSelect an option:")
        print("1. Generate a new encryption key")
        print("2. Encrypt a message")
        print("3. Decrypt a message")
        print("4. Quit")

        choice = input("Enter your choice (1-4): ")

        if choice == "1":
            key = generate_key()
            print("Generated Key:", key.decode())
        elif choice == "2":
            message = input("Enter the message to encrypt: ")
            key = input("Enter the encryption key: ").encode()
            encrypted_message = encrypt_message(message, key)
            print("Encrypted Message:", encrypted_message.decode())
        elif choice == "3":
            encrypted_message = input("Enter the encrypted message: ").encode()
            key = input("Enter the encryption key: ").encode()
            decrypted_message = decrypt_message(encrypted_message, key)
            print("Decrypted Message:", decrypted_message)
        elif choice == "4":
            print("Goodbye!")
            break
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    main()
```

Step 5: Run the `message_encryptor.py` file:
```
python message_encryptor.py
```

The program will display a menu with options to generate a new encryption key, encrypt a message, decrypt a message, or quit.

- To generate a new encryption key, select option 1. The program will generate a random key and display it.
- To encrypt a message, select option 2. Enter the message you want to encrypt and provide the encryption key. The program will encrypt the message using the key and display the encrypted message.
- To decrypt a message, select option 3. Enter the encrypted message and provide the encryption key. The program will decrypt the message using the key and display the decrypted message.
- To quit the program, select option 4.

This basic project demonstrates the use of symmetric encryption using the Fernet algorithm from the cryptography library. The Fernet algorithm provides secure encryption and decryption capabilities.

Note: In a real-world scenario, it's important to securely store and manage encryption keys. This example assumes that the user provides the encryption key manually for simplicity.

Remember to handle exceptions, validate user input, and consider additional security measures when implementing encryption and decryption in a production environment.