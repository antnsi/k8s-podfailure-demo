import os, sys, time

mode = os.getenv("MODE", "normal")

if __name__ == "__main__":
    if mode == "oom":
        # eat memory until OOM
        arr = []
        while True:
            arr.append("x" * 10_000_000)

    elif mode == "fail":
        print(f"Fail...")
        sys.exit(1)

    else:  # normal mode
        for i in range(1000):
            print(f"Normal mode... {i}")
            time.sleep(1)

        sys.exit(0)
