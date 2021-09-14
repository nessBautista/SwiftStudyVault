//
//  main.cpp
//  WorkingSpace
//
//  Created by Nestor Hernandez on 19/06/21.
//

#include <cstdio>

int main() {
    int x = 10;
    int *p = &x;
    int & reference = x;
    printf("x = %d\n", x);
    printf("pointer value = %d\n", *p);
    printf("reference = %d\n", reference);
    
    //Increment x
    printf("------------------");
    ++x;
    printf("x = %d\n", x);
    printf("pointer value = %d\n", *p);
    printf("reference = %d\n", reference);
    
    // Change the reference and notice how it affects all values
    printf("------------------");
    reference = 20;
    printf("x = %d\n", x);
    printf("pointer value = %d\n", *p);
    printf("reference = %d\n", reference);
    
    // You can re-direct the pointer to another value
    printf("------------------");
    int z= 30;
    p = &z;
    printf("pointer value = %d\n", *p);
    printf("reference = %d\n", reference);
    
    // But not a reference
    printf("------------------");
    reference = z;
    printf("x = %d\n", x);
    printf("pointer value = %d\n", *p);
    printf("reference = %d\n", reference);
    
}
