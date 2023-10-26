import os
import requests

FLAG = os.getenv("FLAG", "HTB{n0t_y0ur_k3ys_n0t_y0ur_c01n5}")
SERVER_PORT = os.getenv("SERVER_PORT", "8080")
NAME = os.getenv("NAME", "bitcoinchall")
BANK_ADDR = requests.get(f"http://blockchain_{NAME}_servers:{SERVER_PORT}/env/BANK_ADDR").text
HACKER_ADDR = requests.get(f"http://blockchain_{NAME}_servers:{SERVER_PORT}/env/HACKER_ADDR").text
SRV_IP = os.getenv("SRV_IP", "0.0.0.0")
ELECTRS_PORT = os.getenv("ELECTRS_PORT", "50001")

def get_balance(addr):
    bal_info = requests.get(f"http://blockchain_{NAME}_servers:{SERVER_PORT}/getaddressbalance/{addr}").json()
    confirmed_bal = float(bal_info["confirmed"])
    unmatured_bal = float(bal_info["unconfirmed"])
    
    return confirmed_bal+unmatured_bal


def get_flag():
    if get_balance(HACKER_ADDR) == 0: # check bank bal(?)
        print(FLAG)
    else:
        print("Condition not satisfied.")

def main():
    print("Hello fella, help us recover our bitcoins before it's too late.")
    print(f"Return our Bitcoins to the following address: {BANK_ADDR}")
    print(f"CONNECTION INFO: Network: regtest, Electrum server to connect to blockchain: {SRV_IP}:{ELECTRS_PORT}:t")
    print(f"NOTE: These options might be useful while connecting to the wallet, e.g --regtest --oneserver -s {SRV_IP}:{ELECTRS_PORT}:t")
    print("Hacker wallet must have 0 balance to earn your flag. We want back them all.")
    
    try:
        while True:
            print("\nOptions:")
            print("1) Get flag")
            print("2) Quit")

            choice = input("Enter your choice: ")

            if choice == "1":
                get_flag()
            elif choice == "2":
                print("Goodbye!")
                break
            else:
                print("Invalid choice. Please select a valid option.")
    except KeyboardInterrupt:
        print("\nBye.")

if __name__ == "__main__":
    main()
