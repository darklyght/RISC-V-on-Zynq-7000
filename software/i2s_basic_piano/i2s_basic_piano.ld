SECTIONS
{
    . = 0x10006000;
    .text : {
        * (.start);
        * (.text);
    }
}
