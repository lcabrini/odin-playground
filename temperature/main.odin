package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

Scale :: enum {
    Celsius,
    Fahrenheit,
    Kelvin,
}

main :: proc() {
    scale := read_scale()
    t := read_temperature(scale)

    switch scale {
        case Scale.Celsius:
            fmt.printfln("%.2f degrees C is %.2f degrees F", t, celsius_to_fahrenheit(t))
            fmt.printfln("%.2f degrees C is %.2f degrees K", t, celsius_to_kelvin(t))
        case Scale.Fahrenheit:
            fmt.printfln("%.2f degrees F is %.2f degrees C", t, fahrenheit_to_celsius(t))
            fmt.printfln("%.2f degrees F is %.2f degrees K", t, fahrenheit_to_kelvin(t))
        case Scale.Kelvin:
            fmt.printfln("%.2f degrees K is %.2f degrees C", t, kelvin_to_celsius(t))
            fmt.printfln("%.2f degrees K is %.2f degrees F", t, kelvin_to_fahrenheit(t))
    }
}

read_scale :: proc () -> Scale {
    buf: [64]byte

    fmt.println("Select the temperature you want to convert from: (C)elsius, (F)ahrenheit or (K)elvin.")
    for {
        fmt.print("Your choice: ")
        bytes_read, err := os.read(os.stdin, buf[:])
        if err != nil {
            fmt.eprintln("Unable to read from stdin: ", err)
            os.exit(-1)
        }

        s := string(buf[:bytes_read-1])
        s = strings.trim_space(s)
        s = strings.to_lower(s)

        switch {
            case s == "c" || s == "celsius":
                return Scale.Celsius
            case s == "f" || s == "fahrenheit":
                return Scale.Fahrenheit
            case s == "k" || s == "kelvin":
                return Scale.Kelvin
            case:
                fmt.printfln("'%s' is not a valid temperature scale. Try again.", s)
        }
    }
}

read_temperature :: proc(scale: Scale) -> f32 {
    buf: [64]byte
    name: string
    unit: rune

    switch scale {
        case .Celsius:
            name, unit = "Celsius", 'C'
        case .Fahrenheit:
            name, unit = "Fahrenheit", 'F'
        case .Kelvin:
            name, unit = "Kelvin", 'K'
    }

    for {
        t: f32
        ok: bool

        fmt.printf("Enter temperature in %s (%c): ", scale, unit)
        bytes_read, err := os.read(os.stdin, buf[:])
        if err != nil {
            fmt.eprintln("Unable to read from stdin: ", err)
            os.exit(-1)
        }

        s := string(buf[:bytes_read-1])
        s = strings.trim_space(s)
        if t, ok = strconv.parse_f32(s); !ok {
            fmt.printfln("'%s' is not a valid temperature. Try again.", s)
            continue
        }

        return t
    }
}

fahrenheit_to_celsius :: proc(f: f32) -> f32 {
    return (f - 32) / 1.8
}

fahrenheit_to_kelvin :: proc(f: f32) -> f32 {
    return celsius_to_kelvin(fahrenheit_to_celsius(f))
}

celsius_to_fahrenheit :: proc(c: f32) -> f32 {
    return c * 1.8 + 32
}

celsius_to_kelvin :: proc(c: f32) -> f32 {
    return c + 273.15
}

kelvin_to_fahrenheit :: proc(k: f32) -> f32 {
    return celsius_to_fahrenheit(kelvin_to_celsius(k))
}

kelvin_to_celsius :: proc(k: f32) -> f32 {
    return k - 273.15
}