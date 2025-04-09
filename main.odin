package main


import "core:fmt"

// The build will fail without the required `main` function,
// though we won't use it at all in this example.
main :: proc() {}

// This is the function we'll use in the browser.
// Add the @export() attribute to ensure that the function is
// available in our WASM module.
@(export)
rebuildmepretty2 :: proc(a: i32, b: i32) -> i32 {
	return a + b + 42
}

num_frames :u32= 0
WIDTH  :: 300;
HEIGHT :: 300;

@(export)
BUFFER : [WIDTH * HEIGHT]u32;

@(export)
getBuf :: proc() -> ^[WIDTH*HEIGHT]u32 {
    fmt.println("Got your buffer here!")
    return &BUFFER;
}

// In Odin, we can expose a procedure with `foreign export`
// This allows it to be called from JavaScript if you're using WebAssembly.
@(export)
go :: proc() {
    cx := WIDTH / 2;
    cy := HEIGHT / 2;

    for y in 0..<HEIGHT {
        for x in 0..<WIDTH {
            dx := x - cx;
            dy := y - cy;
            dsq := dx*dx + dy*dy;
            if dsq < 100*100 {
                BUFFER[y * WIDTH + x] = 0xFF0000FF;
            }
            else {
                BUFFER[y * WIDTH + x] = 0xFF223311;
            }
            if x < 10 do BUFFER[y * WIDTH + x] = 0xFFFF0000;
            if y < 10 { BUFFER[y * WIDTH + x] = 0xFF00FF00; }
            if x > (WIDTH-10) do BUFFER[y * WIDTH + x] = 0xFF0000FF;
            if y > (HEIGHT-10) do BUFFER[y * WIDTH + x] = 0xFFFF00FF;
            
        }
    }

}

@(export)
go2 :: proc() {
    for y in 0..<HEIGHT {
        for x in 0..<WIDTH {
            z :u32= u32(x) ~ u32(y);
            BUFFER[y * WIDTH + x] = z | 0xFF_00_00_00;
            BUFFER[y * WIDTH + x] += num_frames;
        }
    }
    num_frames+=1;

}

// Helper function to write to the buffer
render_frame_safe :: proc(buffer: ^[WIDTH * HEIGHT]u32) {
    for i in 0..<len(buffer) {
        buffer[i] = 0xFF1100FF;
    }
}

