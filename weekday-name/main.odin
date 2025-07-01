package main

import "core:fmt"
import "core:os"
import "core:strings"

MALE :: 0
FEMALE :: 1

Weekday :: enum {
    SUNDAY,
    MONDAY,
    TUESDAY,
    WEDNESDAY,
    THURSDAY,
    FRIDAY,
    SATURDAY,
}

/*
SUNDAY :: 0
MONDAY :: 1
TUESDAY :: 2
WEDNESDAY :: 3
THURSDAY :: 4
FRIDAY :: 5
SATURDAY :: 6
*/

main :: proc() {
    sexes := []string{"male", "female"}
    weekdays := []string{"Sunday", "Monday", "Tuesday", "Wednesday", "Thursay", "Friday", "Saturday"}
    names := [2][7]string{
        {"Kwasi", "Kwadwo", "Kwabena", "Kwaku", "Yaw", "Kofi", "Kwame"},
        {"Akosua", "Adwoa", "Abena", "Akua", "Yaa", "Afia", "Ama"},
    }

    sex := read_sex()
    if sex < 0 {
        return
    }

    weekday := read_weekday()
    if weekday == nil {
        return
    }

    fmt.printfln("As a %s born on a %s, your weekday name is %s.", sexes[sex], weekdays[weekday], names[sex][weekday])
}

read_sex :: proc() -> int {
    buf: [512]byte

    for {
        fmt.print("What sex are you (male/female)? ")
        num_bytes, err := os.read(os.stdin, buf[:])
        if err != nil {
            fmt.eprintln("Error reading from stdin: ", err)
            return -1
        }

        sex := string(buf[:num_bytes-1])
        sex = strings.trim_space(sex)
        sex = strings.to_lower(sex)

        switch sex {
            case "male":
                return MALE
            case "female":
                return FEMALE
            case:
                fmt.println("Invalid sex. Try again.")
        }
    }
}

read_weekday :: proc() -> Weekday {
    buf: [512]byte

    for {
        fmt.print("Which day of the week were you born? ")
        num_bytes, err := os.read(os.stdin, buf[:])
        if err != nil {
            fmt.eprintln("Error reading from stdin: ", err)
            return nil
        }

        weekday := string(buf[:num_bytes-1])
        weekday = strings.trim_space(weekday)
        weekday = strings.to_lower(weekday)

        switch weekday {
            case "sunday":
                return Weekday.SUNDAY
            case "monday":
                return Weekday.MONDAY
            case "tuesday":
                return Weekday.TUESDAY
            case "wednesday":
                return Weekday.WEDNESDAY
            case "thursday":
                return Weekday.THURSDAY
            case "friday":
                return Weekday.FRIDAY
            case "saturday":
                return Weekday.SATURDAY
            case:
                fmt.println("Invalid weekday. Try again.")
        }
    }
}