
%include "boot.inc"
SECTION MBR vstart=0x7c00 ;起始地址编译在0x7c00
    mov ax,cs
    mov ds,ax
    mov es,ax
    mov ss,ax
    mov fs,ax
    mov sp,0x7c00
    mov ax,0xb800
    mov gs,ax
    ;这个时候 ds = es = ss = 0 栈指针指向MBR开始位置


    ;ah = 0x06 al = 0x00 想要调用int 0x06的BIOS提供的中断对应的函数 即向上移动即完成清屏功能
    ;cx dx 分别存储左上角与右下角的左边 详情看int 0x06函数调用
    mov ax,0x600 
    mov bx,0x700
    mov cx,0
    mov dx,0x184f
    
    ;调用BIOS中断
    int 0x10 

    mov byte [gs:0x00],'L' ;低位字节储存ascii字符 小端储存内存顺序相反
    mov byte [gs:0x01],0xA4    ;背景储存在第二个字节 含字符与背景属性
    
    mov byte [gs:0x02],'O' 
    mov byte [gs:0x03],0xA4
    
    mov byte [gs:0x04],'V' 
    mov byte [gs:0x05],0xA4
    
    mov byte [gs:0x06],'E' 
    mov byte [gs:0x07],0xA4
    
    mov byte [gs:0x08],'6' 
    mov byte [gs:0x09],0xA4
    
    mov byte [gs:0x0A],' ' 
    mov byte [gs:0x0B],0xA4
    
    mov byte [gs:0x0C],'O' 
    mov byte [gs:0x0D],0xA4
    
    mov byte [gs:0x0E],'S' 
    mov byte [gs:0x0F],0xA4

    mov eax,LOADER_START_SECTOR
    mov bx,LOADER_BASE_ADDR
    mov cx,0x5
    call rd_disk_m_16
    jmp LOADER_BASE_ADDR ;于此处死循环

;du qu yin pan:
;1. 0x1f2 she zhi san qu shu
;2. 0x1f3~0x1f6 she zhi LBA di zhi
;3. 0x1f7 she zhi du ming ling
;4. 0x1f0 du shu ju
rd_disk_m_16:
    mov esi,eax
    mov di,cx

    mov dx,0x1f2
    mov al,cl
    out dx,al

    mov eax,esi

    mov dx,0x1f3
    out dx,al

    inc dx
    mov cl,0x8
    shr eax,cl
    out dx,al

    inc dx
    shr eax,cl
    out dx,al

    inc dx
    shr eax,cl
    and al,0x0f
    or al,0xe0
    out dx,al

    inc dx
    mov al,0x20
    out dx,al

.not_ready:
    nop
    in al,dx
    and al,0x88
    cmp al,0x08
    jnz .not_ready

    mov ax,di      ;把 di 储存的cx 取出来
    mov dx,256
    mul dx        ;di 与 ax 做乘法 计算一共需要读多少次 方便作循环 低16位放ax 高16位放dx
    mov cx,ax      ;loop 与 cx相匹配 cx-- 当cx == 0即跳出循环
    mov dx,0x1f0
 .go_read_loop:
    in ax,dx      ;两字节dx 一次读两字
    mov [bx],ax
    add bx,2
    loop .go_read_loop
    
    ret ;与call 配对返回原来的位置 跳转到call下一条指令
        
    times 510 - ($ - $$) db 0 
    db 0x55,0xaa

    




