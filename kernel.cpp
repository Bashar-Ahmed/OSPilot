extern "C" void my_start_kernel() {
    char* str="cpp kernel";
    short* vga = (short*)0xb8000+80;
    for(int i=0;i<10;i++)
        vga[i] = 0x0F00|str[i];
}
void my_second() {
    const short color = 0x0F00;
    const char* hello = "Hello capp ";
    short* vga = (short*)0xb8000;
    for (int i = 0; i<10;++i)
        vga[i+80] = color | hello[i];
    return;
}