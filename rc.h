#ifndef RC_H_
    #define RC_H_
    #include <stddef.h>
    #define rc_alloc(T,destroy) rc_impl(sizeof(T),destroy)
    #define RED   "\033[31m"
    #define GREEN "\033[32m"
    #define YELLOW "\033[33m"
    #define RESET "\033[0m" 
typedef struct{
    ptrdiff_t count;
    void (*destroy)(void *data);
  }Rc;
    Rc *rc_impl(size_t size,void *destroy);
    void* re_acquire(void *data);
    void rc_release(void *data);
    ptrdiff_t rc_count(void *data);
#endif //RC_H_
#ifdef RC_IMPLEMENTATION
    Rc *rc_impl(size_t size,void *destroy){
    Rc *rc =malloc(sizeof(Rc) + size);
    assert(rc);
    rc->count = 0;
    rc->destroy = destroy;
    printf(YELLOW"[RC]: %p allocated\n"RESET,rc); 
    return rc + 1;
  }
    void *re_acquire(void *data){
    assert(data != NULL);
    Rc *rc = ((Rc*)data -1 );
    rc->count++;
    printf(GREEN"[RC]: %p re-acquired\n"RESET,rc); 
    //1 × sizeof(*ptr) 
    // means rc + 1 = (char*)rc + sizeof(Rc)
    return data;
  }
    void rc_release(void *data){
    assert(data != NULL);  
    Rc *rc = (Rc*)data -1; 
    
    rc->count--;
    if (rc->count <= 0) {
      rc->destroy(data);
      printf(RED"[RC]: %p released\n"RESET,rc);
      free(rc);  // Free The Whole Struct including The Data
    }
  }
  ptrdiff_t rc_count(void* data){
    assert(data != NULL );
    Rc *rc = (Rc*) data -1;
    return rc->count;
  }
#endif 
