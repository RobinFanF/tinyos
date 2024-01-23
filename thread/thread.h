
enum task_status {
    
};

struct task_struct {
    uint32_t* self_kstack;// nei he zhan zhan din
    enum task_status status;
    uint8_t priority;
    char name[16];
    uint32_t stack_magic;
}