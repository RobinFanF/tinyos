#include "print.h"
#include "memory.h"
#include "init.h"

int main(void){
    put_str("welcome to kernel!\n");
    init_all();


    void* addr = get_kernel_pages(1);
    put_str("\n get_kernel_page start vaddr is ");
    put_int((uint32_t)addr);
    put_char('\n');

    //asm volatile("sti");
    while(1);
}