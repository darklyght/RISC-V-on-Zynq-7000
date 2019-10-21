SECTIONS
{
    . = 0x1000a000;
    .text : {
        * (.start);
        * (.text);
    }
}
