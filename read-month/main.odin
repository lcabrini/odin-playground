package main

import "core:fmt"
import "core:os"
import "core:strings"

Month :: enum {
    JANUARY,
    FEBRUARY,
    MARCH,
    APRIL,
    MAY,
    JUNE,
    JULY,
    AUGUST,
    SEPTEMBER,
    OCTOBER,
    NOVEMBER,
    DECEMBER,
}

main :: proc() {
    month := read_month("Enter a month:")
    fmt.printfln("You entered: %v", month)
}

read_month :: proc(prompt: string) -> Month {
    buf: [512]byte

    for {
        fmt.printf("%s ", prompt)
        num_bytes, err := os.read(os.stdin, buf[:])
        if err != nil {
            fmt.eprintln("Error reading from stdin: ", err)
            return nil
        }

        month := string(buf[:num_bytes-1])
        month = strings.trim_space(month)
        month = strings.to_lower(month)

        switch month {
            case "january":
                return Month.JANUARY
            case "february":
                return Month.FEBRUARY
            case "march":
                return Month.MARCH
            case "april":
                return Month.APRIL
            case "may":
                return Month.MAY
            case "june":
                return Month.JUNE
            case "july":
                return Month.JULY
            case "august":
                return Month.AUGUST
            case "september":
                return Month.SEPTEMBER
            case "october":
                return Month.OCTOBER
            case "november":
                return Month.NOVEMBER
            case "december":
                return Month.DECEMBER
            case:
                fmt.printfln("Invalid month: %s. Try again", month)
        }
    }
}