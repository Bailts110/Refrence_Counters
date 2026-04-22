  #include "nob.h"
  #include <assert.h>
  #include <stdarg.h>
  #include <stddef.h>
  #include <stdio.h>
  #include <string.h>
  #include <unistd.h>
  #define RC_IMPLEMENTATION
  #include "rc.h"
  #define RED   "\033[31m"
  #define GREEN "\033[32m"
  #define YELLOW "\033[33m"
  #define RESET "\033[0m"
  // GCC Tries To Solve Halting Problem Like Inifint Recursion
  // The Problem That Control Flow Analysis in GCC didnt Recognize The Abort
  // (NonReturn Function) in TODO Function But The Clang Compiler Didnt Face The
  // GCC Problem So its Like A Missy Thing In GCC Compiler
  // TODO: Search About The Difference of This Problem Between GCC VS Clang
  // https://www.reddit.com/r/programming/comments/dre75v/clang_solves_the_collatz_conjecture/?solution=89630debfd51d0a889630debfd51d0a8&js_challenge=1&token=bbbe4bf1c9a2b5160829c4be34da586177beadfdfe6958148c1a83325a0bb779
  // https://news.ycombinator.com/item?id=40787276
  // forward declaration

  #define rc_data(rc,T) ((T*)(rc + 1))
  // void *rc_data(Rc *rc){
  //   return rc + 1;
  // }
  typedef struct Expr Expr;
  typedef enum {
    EXPR_NIL,
    EXPR_SYMBOL,
    EXPR_INTEGER,
    EXPR_FLOAT,
    EXPR_PAIR,
    __count_expr_kind,
  } Expr_kind;
  // (1234)
  // (Car , CDR) also known  (Left , Right)
  //
  struct Expr {
    Expr_kind kind;
    static_assert(__count_expr_kind == 5,
                  "Amounts of Expression Kinds has Changed");
    union {
      const char *symbol;
      int integer;
      float float_;
      struct {
        Expr *left;
        Expr *right;
      } pair;
    } value;
  };
  //Generic Struct in C 
  // Problem That When Make Two Struct With Same Type its Not the Same Becasue its Anoynoyms
  // #define Rc(T) struct {\
  //     size_t count;\
  //     T data;\
  //   }
  // typedef Rc(Expr) Rc_Expr ;
  // #define rc_new(T) ((T*) (rc_impl(sizeof(T))->data))

  void destroy_expr(void *data){
    Expr *expr =data;
      switch (expr->kind) {
    case EXPR_NIL:
    case EXPR_SYMBOL:
    case EXPR_INTEGER:
    case EXPR_FLOAT:
    break;
    case EXPR_PAIR: {
      rc_release(expr->value.pair.left);
      rc_release(expr->value.pair.right);
    }; break;
    case __count_expr_kind:
    default:
      UNREACHABLE("Invalid Expr Kind");
    }
  }

  Expr *alloc_expr(Expr_kind kind) {
    Expr *expr = (Expr*)  rc_alloc(Expr,destroy_expr);
    // ((Expr *)(expr_rc + 1))->kind = kind;
    // ((Expr *) rc_data(expr_rc))->kind = kind;
    expr->kind = kind;
    return expr;
  }
  static_assert(__count_expr_kind == 5,
                "Amounts of Expression Kinds has Changed. change The Ctors");
  Expr *make_nil(void) { return alloc_expr(EXPR_NIL); }
  Expr *make_symbol(const char *symbol) {
    Expr *expr = alloc_expr(EXPR_SYMBOL);
    expr->value.symbol = symbol;
    return expr;
  }
  Expr *make_integer(int integer) {
    Expr *expr = alloc_expr(EXPR_INTEGER);
    expr->value.integer = integer;
    return expr;
  }
  Expr *make_float(float float_) {
    Expr *expr = alloc_expr(EXPR_FLOAT);
    expr->value.float_ = float_;
    return expr;
  }

  Expr *make_pair(Expr *left, Expr *right) {
    Expr *expr = alloc_expr(EXPR_PAIR);
    expr->value.pair.left = re_acquire(left);
    expr->value.pair.right = re_acquire(right);
    return expr;
  }
  #define dump_expr(expr_rc) dump_expr_opt(expr_rc, 0)
  void dump_expr_opt(Expr *expr, int level) {
    for (int i = 0; i < level; i++) {
      printf("  ");
    }
    switch (expr->kind) {
    case EXPR_NIL:
      printf("NIL(%td)" GREEN" %p\n"RESET,rc_count(expr),expr);
      break;
    case EXPR_SYMBOL:
      printf("SYMBOL(%td): %s"GREEN" %p\n"RESET,rc_count(expr) ,expr->value.symbol,expr);
      break;
    case EXPR_INTEGER:
      printf("INTEGER(%td): %d"GREEN" %p\n"RESET, rc_count(expr),expr->value.integer,expr);
      break;
    case EXPR_FLOAT: {
      printf("FLOAT(%td) %f"GREEN" %p\n"RESET, rc_count(expr),expr->value.float_,expr);
      break;
    }
    case EXPR_PAIR: {
      printf("PAIR(%td):\n",rc_count(expr));
      dump_expr_opt(expr->value.pair.left, level + 1);
      dump_expr_opt(expr->value.pair.right, level + 1);
    }; break;
    case __count_expr_kind:
      UNREACHABLE("Invalid Expr Kind");
    default:
      UNREACHABLE("Invalid Expr Kind");
    }
  }
  // This Recursion Will Cause StackOverflow
  // its Non-Tail Recursive
  // Tail Recursive That Can Compiler Optimize it into Loop and it mean that There
  // no Process After Call
  Expr *args_to_list(va_list args) {
    Expr *arg = va_arg(args, Expr*);
    if (arg->kind == EXPR_NIL)
      return arg;
    return make_pair(arg, args_to_list(args));
  }
  // (...) => ا variadic macro
  #define make_list(...) make_list_impl(NULL, __VA_ARGS__, make_nil())
  Expr *make_list_impl(void *first, ...) {
    va_list args;
    va_start(args, first);
    Expr *list = args_to_list(args);
    va_end(args);
    return list;
  }

  // Expr *make_list_impl(void *first, ...) {
  //   va_list args;
  //   va_start(args, first);
  //   Expr *Head = NULL;
  //   Expr *Tail = NULL;
  //   Expr *nil = make_nil();
  //   while (1) {
  //     Expr *arg = va_arg(args, Expr *);
  //     if (arg->kind == EXPR_NIL){
  //       nil = arg;
  //       break;
  //     }
  //     Expr *node = make_pair(arg,nil);
  //     rc_release(nil);
  //     if (!Head){
  //       Head = Tail = node;
  //     }
  //     else {
  //       Tail->value.pair.right = node;
  //       Tail = node;
  //     }
  //   }
  //   if (Tail) {
  //     Tail->value.pair.right = nil;
  //   }
    
  //   va_end(args);
  //   return Head;
  // }

  Expr *eval(Expr *expr) {
    while (1) {
      Expr *op =  expr->value.pair.left;
    if (expr->kind == EXPR_PAIR) {
      assert(op->kind == EXPR_SYMBOL);
      if (strcmp(op->value.symbol,"swap") == 0) {
          Expr *args = expr->value.pair.right;
          assert(args->kind == EXPR_PAIR);
          assert(args->value.pair.right->kind == EXPR_PAIR);
          assert(args->value.pair.right->value.pair.right->kind == EXPR_NIL);
          Expr *arg =  (args->value.pair.left);
          Expr *arg2 =  (args->value.pair.right->value.pair.left);
          return make_pair(arg2, arg);
      }
      if (strcmp(op->value.symbol,"eval") == 0) {
        expr = expr->value.pair.right;
        continue;
      }
      if (strcmp(op->value.symbol, "+") == 0) {
        //(+,(2,(3,15),))
        int result = 0;
        Expr *args = expr->value.pair.right;
        while (args->kind != EXPR_NIL) {
          assert(args->kind == EXPR_PAIR);
          assert(args->value.pair.left->kind == EXPR_INTEGER);
          result += args->value.pair.left->value.integer;
          args = args->value.pair.right;
        }
        return make_integer(result);
      } 
      else if (strcmp(op->value.symbol, "-") == 0) {
        Expr *args = expr->value.pair.right;
        int result = args->value.pair.left->value.integer;
        args = args->value.pair.right;
        while (args->kind != EXPR_NIL) {
          assert(args->kind == EXPR_PAIR);
          assert(args->value.pair.left->kind == EXPR_INTEGER);
          result -= args->value.pair.left->value.integer;
          args = args->value.pair.right;
        }
        return make_integer(result);
      } else if (strcmp(op->value.symbol, "*") == 0) {
        int result = 1;
        Expr *args = expr->value.pair.right;
        while (args->kind != EXPR_NIL) {
          assert(args->kind == EXPR_PAIR);
          assert(args->value.pair.left->kind == EXPR_INTEGER);
          result *= args->value.pair.left->value.integer;
          args = args->value.pair.right;
        }
        return make_integer(result);
      } else if (strcmp(op->value.symbol, "/") == 0) {
        Expr *args = expr->value.pair.right;
        assert(args->value.pair.left->kind == EXPR_INTEGER);
        int result = args->value.pair.left->value.integer;
        args = args->value.pair.right;
        while (args->kind != EXPR_NIL) {
          assert(args->kind == EXPR_PAIR);
          Expr *next = args->value.pair.left;
          assert(next->kind == EXPR_INTEGER);
          if (next->value.integer == 0) {
            TODO("Report Division by Zero Error");
          }
          result /= next->value.integer;
          args = args->value.pair.right;
        }
        return make_integer(result);
      }
      else {
        UNREACHABLE("Unknown Function Error");
      }
    }
    return expr;
    }

  }
  int main() {
    // Expr *x = make_symbol("x");
    // Expr *y = make_symbol("y");
    // Expr *pair =  make_pair(x, y);
    // (1,(2,(3,(4s,(Nil)))))
    // Expr *list =
    //     make_pair(make_symbol("1"),
    //               make_pair(make_symbol("2"),
    //                         make_pair(make_symbol("3"),
    //                                   make_pair(make_symbol("4s"),
    //                                   make_nil()))));
    // dump_expr(list);
    // Expr *funcall =
    //     make_pair(make_symbol("+"), make_list(make_integer(1), make_integer(2),
    //                                           make_integer(3), make_integer(4),make_integer(5)));
    printf("-------Expr---------\n");
    Expr *funcall =
        (make_pair(make_symbol("swap"), make_list(make_integer(8), make_integer(4))));    
        printf("-------Eval---------\n");
        Expr *result = re_acquire(eval(funcall));
        printf("-------Dump Expression---------\n");
        printf("Expr = \n");
        dump_expr(funcall);
        printf("Result = \n");
        dump_expr(result);
        printf("-------Release Expression---------\n");
        rc_release(funcall);
        printf("Result = \n");
        dump_expr(result);
        printf("-------Release Result---------\n");        
        rc_release(result);

    return 0;
  }
