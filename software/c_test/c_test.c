int mult(int a, int b);

int main(void) {
    
    int a = 3, b = 5, c;
    
    c = mult(a, b);
    
    return 0;
}

int mult(int a, int b) {
    int i, result = 0;
    
    for (i = 0; i < b; i++) {
        result += a;
    }
    
    return result;
}
