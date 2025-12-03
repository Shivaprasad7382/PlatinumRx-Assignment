# 02_Remove_Duplicates.py
def remove_duplicates(s):
    if s is None:
        return ""
    result = ""
    for ch in s:
        if ch not in result:
            result += ch
    return result

# Examples
if __name__ == "__main__":
    print(remove_duplicates("aabbccddeeff"))   # "abcdef"
    print(remove_duplicates("hello world"))    # "helo wrd"
