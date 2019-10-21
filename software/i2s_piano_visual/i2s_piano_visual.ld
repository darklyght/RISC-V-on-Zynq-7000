SECTIONS
{
    uart_control = 0x80000000;
    uart_rx      = 0x80000004;
    uart_tx      = 0x80000008;
    i2s_full    = 0x80000040;
    i2s_sample  = 0x80000044;

    . = 0x10006000;
    .text : {
        * (.start);
        * (.text);
    }
}
