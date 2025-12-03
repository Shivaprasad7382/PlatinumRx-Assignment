# 01_Time_Converter.py
def convert_minutes(total_minutes):
    if total_minutes is None:
        return ""
    if total_minutes < 0:
        raise ValueError("Minutes cannot be negative")

    hours = total_minutes // 60
    minutes = total_minutes % 60

    hr_label = "hr" if hours == 1 else "hrs"
    min_label = "minute" if minutes == 1 else "minutes"

    if hours > 0 and minutes > 0:
        return f"{hours} {hr_label} {minutes} {min_label}"
    elif hours > 0:
        return f"{hours} {hr_label}"
    else:
        return f"{minutes} {min_label}"

# Examples
if __name__ == "__main__":
    print(convert_minutes(130))   # "2 hrs 10 minutes"
    print(convert_minutes(110))   # "1 hr 50 minutes"
    print(convert_minutes(45))    # "45 minutes"
    print(convert_minutes(60))    # "1 hr"
