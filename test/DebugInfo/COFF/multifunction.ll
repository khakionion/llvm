; RUN: llc -mcpu=core2 -mtriple=i686-pc-win32 -O0 < %s | FileCheck --check-prefix=X86 %s
; RUN: llc -mcpu=core2 -mtriple=i686-pc-win32 -o - -O0 < %s | llvm-mc -triple=i686-pc-win32 -filetype=obj | llvm-readobj -s -sr -codeview -section-symbols | FileCheck --check-prefix=OBJ32 %s
; RUN: llc -mcpu=core2 -mtriple=x86_64-pc-win32 -O0 < %s | FileCheck --check-prefix=X64 %s
; RUN: llc -mcpu=core2 -mtriple=x86_64-pc-win32 -o - -O0 < %s | llvm-mc -triple=x86_64-pc-win32 -filetype=obj | llvm-readobj -s -sr -codeview -section-symbols | FileCheck --check-prefix=OBJ64 %s

; This LL file was generated by running clang on the following code:
; D:\source.c:
;  1 void z(void);
;  2
;  3 void x(void) {
;  4   z();
;  5 }
;  6
;  7 void y(void) {
;  8   z();
;  9 }
; 10
; 11 void f(void) {
; 12   x();
; 13   y();
; 14   z();
; 15 }


; X86-LABEL: _x:
; X86:      # BB
; X86-NEXT: [[X_CALL:.*]]:{{$}}
; X86:      calll   _z
; X86-NEXT: [[X_RETURN:.*]]:
; X86:      ret
; X86-NEXT: [[END_OF_X:.*]]:
;
; X86-LABEL: _y:
; X86:      # BB
; X86-NEXT: [[Y_CALL:.*]]:{{$}}
; X86:      calll   _z
; X86-NEXT: [[Y_RETURN:.*]]:
; X86:      ret
; X86-NEXT: [[END_OF_Y:.*]]:
;
; X86-LABEL: _f:
; X86:      # BB
; X86-NEXT: [[F_CALLS_X:.*]]:{{$}}
; X86:      calll   _x
; X86-NEXT: [[F_CALLS_Y:.*]]:
; X86:      calll   _y
; X86-NEXT: [[F_CALLS_Z:.*]]:
; X86:      calll   _z
; X86-NEXT: [[F_RETURN:.*]]:
; X86:      ret
; X86-NEXT: [[END_OF_F:.*]]:
;
; X86-LABEL: .section        .debug$S,"dr"
; X86-NEXT: .long   4
; Symbol subsection for x
; X86-NEXT: .long   241
; X86-NEXT: .long [[F1_END:.*]]-[[F1_START:.*]]
; X86-NEXT: [[F1_START]]:
; X86-NEXT: .short [[PROC_SEGMENT_END:.*]]-[[PROC_SEGMENT_START:.*]]
; X86-NEXT: [[PROC_SEGMENT_START]]:
; X86-NEXT: .short  4423
; X86-NEXT: .zero   12
; X86-NEXT: .long [[END_OF_X]]-_x
; X86-NEXT: .zero   12
; X86-NEXT: .secrel32 _x
; X86-NEXT: .secidx _x
; X86-NEXT: .byte   0
; X86-NEXT: .byte   120
; X86-NEXT: .byte   0
; X86-NEXT: [[PROC_SEGMENT_END]]:
; X86-NEXT: .short  2
; X86-NEXT: .short  4431
; X86-NEXT: [[F1_END]]:
; Padding
; X86-NEXT: .zero   3
; Line table subsection for x
; X86-NEXT: .long   242
; X86-NEXT: .long [[F2_END:.*]]-[[F2_START:.*]]
; X86-NEXT: [[F2_START]]:
; X86-NEXT: .secrel32       _x
; X86-NEXT: .secidx _x
; X86-NEXT: .short 1
; X86-NEXT: .long [[END_OF_X]]-_x
; X86-NEXT: [[FILE_SEGMENT_START:[^:]*]]:
; X86-NEXT: .long   0
; X86-NEXT: .long   2
; X86-NEXT: .long [[FILE_SEGMENT_END:.*]]-[[FILE_SEGMENT_START]]
; X86-NEXT: .long [[X_CALL]]-_x
; X86-NEXT: .long   4
; X86-NEXT: .long [[X_RETURN]]-_x
; X86-NEXT: .long   5
; X86-NEXT: .short 42
; X86-NEXT: .short 42
; X86-NEXT: .short 43
; X86-NEXT: .short 43
; X86-NEXT: [[FILE_SEGMENT_END]]:
; X86-NEXT: [[F2_END]]:
; Symbol subsection for y
; X86-NEXT: .long   241
; X86-NEXT: .long [[F1_END:.*]]-[[F1_START:.*]]
; X86-NEXT: [[F1_START]]:
; X86-NEXT: .short [[PROC_SEGMENT_END:.*]]-[[PROC_SEGMENT_START:.*]]
; X86-NEXT: [[PROC_SEGMENT_START]]:
; X86-NEXT: .short  4423
; X86-NEXT: .zero   12
; X86-NEXT: .long [[END_OF_Y]]-_y
; X86-NEXT: .zero   12
; X86-NEXT: .secrel32 _y
; X86-NEXT: .secidx _y
; X86-NEXT: .byte   0
; X86-NEXT: .byte   121
; X86-NEXT: .byte   0
; X86-NEXT: [[PROC_SEGMENT_END]]:
; X86-NEXT: .short  2
; X86-NEXT: .short  4431
; X86-NEXT: [[F1_END]]:
; Padding
; X86-NEXT: .zero   3
; Line table subsection for y
; X86-NEXT: .long   242
; X86-NEXT: .long [[F2_END:.*]]-[[F2_START:.*]]
; X86-NEXT: [[F2_START]]:
; X86-NEXT: .secrel32       _y
; X86-NEXT: .secidx _y
; X86-NEXT: .short 1
; X86-NEXT: .long [[END_OF_Y]]-_y
; X86-NEXT: [[FILE_SEGMENT_START:[^:]*]]:
; X86-NEXT: .long   0
; X86-NEXT: .long   2
; X86-NEXT: .long [[FILE_SEGMENT_END:.*]]-[[FILE_SEGMENT_START]]
; X86-NEXT: .long [[Y_CALL]]-_y
; X86-NEXT: .long   8
; X86-NEXT: .long [[Y_RETURN]]-_y
; X86-NEXT: .long   9
; X86-NEXT: .short 52
; X86-NEXT: .short 52
; X86-NEXT: .short 53
; X86-NEXT: .short 53
; X86-NEXT: [[FILE_SEGMENT_END]]:
; X86-NEXT: [[F2_END]]:
; Symbol subsection for f
; X86-NEXT: .long   241
; X86-NEXT: .long [[F1_END:.*]]-[[F1_START:.*]]
; X86-NEXT: [[F1_START]]:
; X86-NEXT: .short [[PROC_SEGMENT_END:.*]]-[[PROC_SEGMENT_START:.*]]
; X86-NEXT: [[PROC_SEGMENT_START]]:
; X86-NEXT: .short  4423
; X86-NEXT: .zero   12
; X86-NEXT: .long [[END_OF_F]]-_f
; X86-NEXT: .zero   12
; X86-NEXT: .secrel32 _f
; X86-NEXT: .secidx _f
; X86-NEXT: .byte   0
; X86-NEXT: .byte   102
; X86-NEXT: .byte   0
; X86-NEXT: [[PROC_SEGMENT_END]]:
; X86-NEXT: .short  2
; X86-NEXT: .short  4431
; X86-NEXT: [[F1_END]]:
; Padding
; X86-NEXT: .zero   3
; Line table subsection for f
; X86-NEXT: .long   242
; X86-NEXT: .long [[F2_END:.*]]-[[F2_START:.*]]
; X86-NEXT: [[F2_START]]:
; X86-NEXT: .secrel32 _f
; X86-NEXT: .secidx _f
; X86-NEXT: .short 1
; X86-NEXT: .long [[END_OF_F]]-_f
; X86-NEXT: [[FILE_SEGMENT_START:[^:]*]]:
; X86-NEXT: .long   0
; X86-NEXT: .long   4
; X86-NEXT: .long [[FILE_SEGMENT_END:.*]]-[[FILE_SEGMENT_START]]
; X86-NEXT: .long [[F_CALLS_X]]-_f
; X86-NEXT: .long   12
; X86-NEXT: .long [[F_CALLS_Y]]-_f
; X86-NEXT: .long   13
; X86-NEXT: .long [[F_CALLS_Z]]-_f
; X86-NEXT: .long   14
; X86-NEXT: .long [[F_RETURN]]-_f
; X86-NEXT: .long   15
; X86-NEXT: .short 62
; X86-NEXT: .short 62
; X86-NEXT: .short 63
; X86-NEXT: .short 63
; X86-NEXT: .short 72
; X86-NEXT: .short 72
; X86-NEXT: .short 73
; X86-NEXT: .short 73
; X86-NEXT: [[FILE_SEGMENT_END]]:
; X86-NEXT: [[F2_END]]:
; File index to string table offset subsection
; X86-NEXT: .long   244
; X86-NEXT: .long   8
; X86-NEXT: .long   1
; X86-NEXT: .long   0
; String table
; X86-NEXT: .long   243
; X86-NEXT: .long   13
; X86-NEXT: .byte   0
; X86-NEXT: .ascii  "D:\\source.c"
; X86-NEXT: .byte   0
; X86-NEXT: .zero   3

; OBJ32:    Section {
; OBJ32:      Name: .debug$S (2E 64 65 62 75 67 24 53)
; OBJ32:      Characteristics [ (0x42100040)
; OBJ32:      ]
; OBJ32:      Relocations [
; OBJ32-NEXT:   0x2C IMAGE_REL_I386_SECREL _x
; OBJ32-NEXT:   0x30 IMAGE_REL_I386_SECTION _x
; OBJ32-NEXT:   0x44 IMAGE_REL_I386_SECREL _x
; OBJ32-NEXT:   0x48 IMAGE_REL_I386_SECTION _x
; OBJ32-NEXT:   0x9C IMAGE_REL_I386_SECREL _y
; OBJ32-NEXT:   0xA0 IMAGE_REL_I386_SECTION _y
; OBJ32-NEXT:   0xB4 IMAGE_REL_I386_SECREL _y
; OBJ32-NEXT:   0xB8 IMAGE_REL_I386_SECTION _y
; OBJ32-NEXT:   0x10C IMAGE_REL_I386_SECREL _f
; OBJ32-NEXT:   0x110 IMAGE_REL_I386_SECTION _f
; OBJ32-NEXT:   0x124 IMAGE_REL_I386_SECREL _f
; OBJ32-NEXT:   0x128 IMAGE_REL_I386_SECTION _f
; OBJ32-NEXT: ]
; OBJ32:      Subsection [
; OBJ32-NEXT:   Type: 0xF1
; OBJ32-NOT:    ]
; OBJ32:        ProcStart {
; OBJ32-NEXT:     DisplayName: x
; OBJ32-NEXT:     Section: _x
; OBJ32-NEXT:     CodeSize: 0x6
; OBJ32-NEXT:   }
; OBJ32-NEXT:   ProcEnd
; OBJ32-NEXT: ]
; OBJ32:      Subsection [
; OBJ32-NEXT:   Type: 0xF2
; OBJ32:      ]
; OBJ32:      Subsection [
; OBJ32-NEXT:   Type: 0xF1
; OBJ32-NOT:    ]
; OBJ32:        ProcStart {
; OBJ32-NEXT:     DisplayName: y
; OBJ32-NEXT:     Section: _y
; OBJ32-NEXT:     CodeSize: 0x6
; OBJ32-NEXT:   }
; OBJ32-NEXT:   ProcEnd
; OBJ32-NEXT: ]
; OBJ32:      Subsection [
; OBJ32-NEXT:   Type: 0xF2
; OBJ32:      ]
; OBJ32:      Subsection [
; OBJ32-NEXT:   Type: 0xF1
; OBJ32-NOT:    ]
; OBJ32:        ProcStart {
; OBJ32-NEXT:     DisplayName: f
; OBJ32-NEXT:     Section: _f
; OBJ32-NEXT:     CodeSize: 0x10
; OBJ32-NEXT:   }
; OBJ32-NEXT:   ProcEnd
; OBJ32-NEXT: ]
; OBJ32:      Subsection [
; OBJ32-NEXT:   Type: 0xF2
; OBJ32:      ]
; OBJ32:      FunctionLineTable [
; OBJ32-NEXT:   Name: _x
; OBJ32-NEXT:   Flags: 0x1
; OBJ32-NEXT:   CodeSize: 0x6
; OBJ32-NEXT:   FilenameSegment [
; OBJ32-NEXT:     Filename: D:\source.c
; OBJ32-NEXT:     +0x0: 4
; OBJ32-NEXT:     +0x5: 5
; OBJ32-NEXT:     ColStart: 42
; OBJ32-NEXT:     ColEnd: 42
; OBJ32-NEXT:     ColStart: 43
; OBJ32-NEXT:     ColEnd: 43
; OBJ32-NEXT:   ]
; OBJ32-NEXT: ]
; OBJ32-NEXT: FunctionLineTable [
; OBJ32-NEXT:   Name: _y
; OBJ32-NEXT:   Flags: 0x1
; OBJ32-NEXT:   CodeSize: 0x6
; OBJ32-NEXT:   FilenameSegment [
; OBJ32-NEXT:     Filename: D:\source.c
; OBJ32-NEXT:     +0x0: 8
; OBJ32-NEXT:     +0x5: 9
; OBJ32-NEXT:     ColStart: 52
; OBJ32-NEXT:     ColEnd: 52
; OBJ32-NEXT:     ColStart: 53
; OBJ32-NEXT:     ColEnd: 53
; OBJ32-NEXT:   ]
; OBJ32-NEXT: ]
; OBJ32-NEXT: FunctionLineTable [
; OBJ32-NEXT:   Name: _f
; OBJ32-NEXT:   Flags: 0x1
; OBJ32-NEXT:   CodeSize: 0x10
; OBJ32-NEXT:   FilenameSegment [
; OBJ32-NEXT:     Filename: D:\source.c
; OBJ32-NEXT:     +0x0: 12
; OBJ32-NEXT:     +0x5: 13
; OBJ32-NEXT:     +0xA: 14
; OBJ32-NEXT:     +0xF: 15
; OBJ32-NEXT:     ColStart: 62
; OBJ32-NEXT:     ColEnd: 62
; OBJ32-NEXT:     ColStart: 63
; OBJ32-NEXT:     ColEnd: 63
; OBJ32-NEXT:     ColStart: 72
; OBJ32-NEXT:     ColEnd: 72
; OBJ32-NEXT:     ColStart: 73
; OBJ32-NEXT:     ColEnd: 73
; OBJ32-NEXT:   ]
; OBJ32-NEXT: ]
; OBJ32:    }

; X64-LABEL: x:
; X64-NEXT: .L{{.*}}:
; X64-NEXT: [[X_START:.*]]:{{$}}
; X64:      # BB
; X64:      subq    $40, %rsp
; X64-NEXT: [[X_CALL_LINE:.*]]:{{$}}
; X64-NEXT: callq   z
; X64-NEXT: [[X_EPILOG_AND_RET:.*]]:
; X64:      addq    $40, %rsp
; X64-NEXT: ret
; X64-NEXT: [[END_OF_X:.*]]:
;
; X64-LABEL: y:
; X64-NEXT: .L{{.*}}:
; X64-NEXT: [[Y_START:.*]]:{{$}}
; X64:      # BB
; X64:      subq    $40, %rsp
; X64-NEXT: [[Y_CALL_LINE:.*]]:{{$}}
; X64-NEXT: callq   z
; X64-NEXT: [[Y_EPILOG_AND_RET:.*]]:
; X64:      addq    $40, %rsp
; X64-NEXT: ret
; X64-NEXT: [[END_OF_Y:.*]]:
;
; X64-LABEL: f:
; X64-NEXT: .L{{.*}}:
; X64-NEXT: [[F_START:.*]]:{{$}}
; X64:      # BB
; X64:      subq    $40, %rsp
; X64-NEXT: [[F_CALLS_X:.*]]:{{$}}
; X64-NEXT: callq   x
; X64-NEXT: [[F_CALLS_Y:.*]]:
; X64:      callq   y
; X64-NEXT: [[F_CALLS_Z:.*]]:
; X64:      callq   z
; X64-NEXT: [[F_EPILOG_AND_RET:.*]]:
; X64:      addq    $40, %rsp
; X64-NEXT: ret
; X64-NEXT: [[END_OF_F:.*]]:
;
; X64-LABEL: .section        .debug$S,"dr"
; X64-NEXT: .long   4
; Symbol subsection for x
; X64-NEXT: .long   241
; X64-NEXT: .long [[F1_END:.*]]-[[F1_START:.*]]
; X64-NEXT: [[F1_START]]:
; X64-NEXT: .short [[PROC_SEGMENT_END:.*]]-[[PROC_SEGMENT_START:.*]]
; X64-NEXT: [[PROC_SEGMENT_START]]:
; X64-NEXT: .short  4423
; X64-NEXT: .zero   12
; X64-NEXT: .long [[END_OF_X]]-x
; X64-NEXT: .zero   12
; X64-NEXT: .secrel32 x
; X64-NEXT: .secidx x
; X64-NEXT: .byte   0
; X64-NEXT: .byte   120
; X64-NEXT: .byte   0
; X64-NEXT: [[PROC_SEGMENT_END]]:
; X64-NEXT: .short  2
; X64-NEXT: .short  4431
; X64-NEXT: [[F1_END]]:
; Padding
; X64-NEXT: .zero   3
; Line table subsection for x
; X64-NEXT: .long   242
; X64-NEXT: .long [[F2_END:.*]]-[[F2_START:.*]]
; X64-NEXT: [[F2_START]]:
; X64-NEXT: .secrel32 x
; X64-NEXT: .secidx x
; X64-NEXT: .short 1
; X64-NEXT: .long [[END_OF_X]]-x
; X64-NEXT: [[FILE_SEGMENT_START:[^:]*]]:
; X64-NEXT: .long   0
; X64-NEXT: .long   3
; X64-NEXT: .long [[FILE_SEGMENT_END:.*]]-[[FILE_SEGMENT_START]]
; X64-NEXT: .long [[X_START]]-x
; X64-NEXT: .long   3
; X64-NEXT: .long [[X_CALL_LINE]]-x
; X64-NEXT: .long   4
; X64-NEXT: .long [[X_EPILOG_AND_RET]]-x
; X64-NEXT: .long   5
; X64-NEXT: .short 0
; X64-NEXT: .short 0
; X64-NEXT: .short 42
; X64-NEXT: .short 42
; X64-NEXT: .short 43
; X64-NEXT: .short 43
; X64-NEXT: [[FILE_SEGMENT_END]]:
; X64-NEXT: [[F2_END]]:
; Symbol subsection for y
; X64-NEXT: .long   241
; X64-NEXT: .long [[F1_END:.*]]-[[F1_START:.*]]
; X64-NEXT: [[F1_START]]:
; X64-NEXT: .short [[PROC_SEGMENT_END:.*]]-[[PROC_SEGMENT_START:.*]]
; X64-NEXT: [[PROC_SEGMENT_START]]:
; X64-NEXT: .short  4423
; X64-NEXT: .zero   12
; X64-NEXT: .long [[END_OF_Y]]-y
; X64-NEXT: .zero   12
; X64-NEXT: .secrel32 y
; X64-NEXT: .secidx y
; X64-NEXT: .byte   0
; X64-NEXT: .byte   121
; X64-NEXT: .byte   0
; X64-NEXT: [[PROC_SEGMENT_END]]:
; X64-NEXT: .short  2
; X64-NEXT: .short  4431
; X64-NEXT: [[F1_END]]:
; Padding
; X64-NEXT: .zero   3
; Line table subsection for y
; X64-NEXT: .long   242
; X64-NEXT: .long [[F2_END:.*]]-[[F2_START:.*]]
; X64-NEXT: [[F2_START]]:
; X64-NEXT: .secrel32 y
; X64-NEXT: .secidx y
; X64-NEXT: .short 1
; X64-NEXT: .long [[END_OF_Y]]-y
; X64-NEXT: [[FILE_SEGMENT_START:[^:]*]]:
; X64-NEXT: .long   0
; X64-NEXT: .long   3
; X64-NEXT: .long [[FILE_SEGMENT_END:.*]]-[[FILE_SEGMENT_START]]
; X64-NEXT: .long [[Y_START]]-y
; X64-NEXT: .long   7
; X64-NEXT: .long [[Y_CALL_LINE]]-y
; X64-NEXT: .long   8
; X64-NEXT: .long [[Y_EPILOG_AND_RET]]-y
; X64-NEXT: .long   9
; X64-NEXT: .short 0
; X64-NEXT: .short 0
; X64-NEXT: .short 52
; X64-NEXT: .short 52
; X64-NEXT: .short 53
; X64-NEXT: .short 53
; X64-NEXT: [[FILE_SEGMENT_END]]:
; X64-NEXT: [[F2_END]]:
; Symbol subsection for f
; X64-NEXT: .long   241
; X64-NEXT: .long [[F1_END:.*]]-[[F1_START:.*]]
; X64-NEXT: [[F1_START]]:
; X64-NEXT: .short [[PROC_SEGMENT_END:.*]]-[[PROC_SEGMENT_START:.*]]
; X64-NEXT: [[PROC_SEGMENT_START]]:
; X64-NEXT: .short  4423
; X64-NEXT: .zero   12
; X64-NEXT: .long [[END_OF_F]]-f
; X64-NEXT: .zero   12
; X64-NEXT: .secrel32 f
; X64-NEXT: .secidx f
; X64-NEXT: .byte   0
; X64-NEXT: .byte   102
; X64-NEXT: .byte   0
; X64-NEXT: [[PROC_SEGMENT_END]]:
; X64-NEXT: .short  2
; X64-NEXT: .short  4431
; X64-NEXT: [[F1_END]]:
; Padding
; X64-NEXT: .zero   3
; Line table subsection for f
; X64-NEXT: .long   242
; X64-NEXT: .long [[F2_END:.*]]-[[F2_START:.*]]
; X64-NEXT: [[F2_START]]:
; X64-NEXT: .secrel32 f
; X64-NEXT: .secidx f
; X64-NEXT: .short 1
; X64-NEXT: .long [[END_OF_F]]-f
; X64-NEXT: [[FILE_SEGMENT_START:[^:]*]]:
; X64-NEXT: .long   0
; X64-NEXT: .long   5
; X64-NEXT: .long [[FILE_SEGMENT_END:.*]]-[[FILE_SEGMENT_START]]
; X64-NEXT: .long [[F_START]]-f
; X64-NEXT: .long   11
; X64-NEXT: .long [[F_CALLS_X]]-f
; X64-NEXT: .long   12
; X64-NEXT: .long [[F_CALLS_Y]]-f
; X64-NEXT: .long   13
; X64-NEXT: .long [[F_CALLS_Z]]-f
; X64-NEXT: .long   14
; X64-NEXT: .long [[F_EPILOG_AND_RET]]-f
; X64-NEXT: .long   15
; X64-NEXT: .short 0
; X64-NEXT: .short 0
; X64-NEXT: .short 62
; X64-NEXT: .short 62
; X64-NEXT: .short 63
; X64-NEXT: .short 63
; X64-NEXT: .short 72
; X64-NEXT: .short 72
; X64-NEXT: .short 73
; X64-NEXT: .short 73
; X64-NEXT: [[FILE_SEGMENT_END]]:
; X64-NEXT: [[F2_END]]:
; File index to string table offset subsection
; X64-NEXT: .long   244
; X64-NEXT: .long   8
; X64-NEXT: .long   1
; X64-NEXT: .long   0
; String table
; X64-NEXT: .long   243
; X64-NEXT: .long   13
; X64-NEXT: .byte   0
; X64-NEXT: .ascii  "D:\\source.c"
; X64-NEXT: .byte   0
; X64-NEXT: .zero   3

; OBJ64:    Section {
; OBJ64:      Name: .debug$S (2E 64 65 62 75 67 24 53)
; OBJ64:      Characteristics [ (0x42100040)
; OBJ64:      ]
; OBJ64:      Relocations [
; OBJ64-NEXT:   0x2C IMAGE_REL_AMD64_SECREL x
; OBJ64-NEXT:   0x30 IMAGE_REL_AMD64_SECTION x
; OBJ64-NEXT:   0x44 IMAGE_REL_AMD64_SECREL x
; OBJ64-NEXT:   0x48 IMAGE_REL_AMD64_SECTION x
; OBJ64-NEXT:   0xA8 IMAGE_REL_AMD64_SECREL y
; OBJ64-NEXT:   0xAC IMAGE_REL_AMD64_SECTION y
; OBJ64-NEXT:   0xC0 IMAGE_REL_AMD64_SECREL y
; OBJ64-NEXT:   0xC4 IMAGE_REL_AMD64_SECTION y
; OBJ64-NEXT:   0x124 IMAGE_REL_AMD64_SECREL f
; OBJ64-NEXT:   0x128 IMAGE_REL_AMD64_SECTION f
; OBJ64-NEXT:   0x13C IMAGE_REL_AMD64_SECREL f
; OBJ64-NEXT:   0x140 IMAGE_REL_AMD64_SECTION f
; OBJ64-NEXT: ]
; OBJ64:      Subsection [
; OBJ64-NEXT:   Type: 0xF1
; OBJ64-NOT:    ]
; OBJ64:        ProcStart {
; OBJ64-NEXT:     DisplayName: x
; OBJ64-NEXT:     Section: x
; OBJ64-NEXT:     CodeSize: 0xE
; OBJ64-NEXT:   }
; OBJ64-NEXT:   ProcEnd
; OBJ64-NEXT: ]
; OBJ64:      Subsection [
; OBJ64-NEXT:   Type: 0xF2
; OBJ64:      ]
; OBJ64:      Subsection [
; OBJ64-NEXT:   Type: 0xF1
; OBJ64-NOT:    ]
; OBJ64:        ProcStart {
; OBJ64-NEXT:     DisplayName: y
; OBJ64-NEXT:     Section: y
; OBJ64-NEXT:     CodeSize: 0xE
; OBJ64-NEXT:   }
; OBJ64-NEXT:   ProcEnd
; OBJ64-NEXT: ]
; OBJ64:      Subsection [
; OBJ64-NEXT:   Type: 0xF2
; OBJ64:      ]
; OBJ64:      Subsection [
; OBJ64-NEXT:   Type: 0xF1
; OBJ64-NOT:    ]
; OBJ64:        ProcStart {
; OBJ64-NEXT:     DisplayName: f
; OBJ64-NEXT:     Section: f
; OBJ64-NEXT:     CodeSize: 0x18
; OBJ64-NEXT:   }
; OBJ64-NEXT:   ProcEnd
; OBJ64-NEXT: ]
; OBJ64:      Subsection [
; OBJ64-NEXT:   Type: 0xF2
; OBJ64:      ]
; OBJ64:      FunctionLineTable [
; OBJ64-NEXT:   Name: x
; OBJ64-NEXT:   Flags: 0x1
; OBJ64-NEXT:   CodeSize: 0xE
; OBJ64-NEXT:   FilenameSegment [
; OBJ64-NEXT:     Filename: D:\source.c
; OBJ64-NEXT:     +0x0: 3
; OBJ64-NEXT:     +0x4: 4
; OBJ64-NEXT:     +0x9: 5
; OBJ64-NEXT:     ColStart: 0
; OBJ64-NEXT:     ColEnd: 0
; OBJ64-NEXT:     ColStart: 42
; OBJ64-NEXT:     ColEnd: 42
; OBJ64-NEXT:     ColStart: 43
; OBJ64-NEXT:     ColEnd: 43
; OBJ64-NEXT:   ]
; OBJ64-NEXT: ]
; OBJ64-NEXT: FunctionLineTable [
; OBJ64-NEXT:   Name: y
; OBJ64-NEXT:   Flags: 0x1
; OBJ64-NEXT:   CodeSize: 0xE
; OBJ64-NEXT:   FilenameSegment [
; OBJ64-NEXT:     Filename: D:\source.c
; OBJ64-NEXT:     +0x0: 7
; OBJ64-NEXT:     +0x4: 8
; OBJ64-NEXT:     +0x9: 9
; OBJ64-NEXT:     ColStart: 0
; OBJ64-NEXT:     ColEnd: 0
; OBJ64-NEXT:     ColStart: 52
; OBJ64-NEXT:     ColEnd: 52
; OBJ64-NEXT:     ColStart: 53
; OBJ64-NEXT:     ColEnd: 53
; OBJ64-NEXT:   ]
; OBJ64-NEXT: ]
; OBJ64-NEXT: FunctionLineTable [
; OBJ64-NEXT:   Name: f
; OBJ64-NEXT:   Flags: 0x1
; OBJ64-NEXT:   CodeSize: 0x18
; OBJ64-NEXT:   FilenameSegment [
; OBJ64-NEXT:     Filename: D:\source.c
; OBJ64-NEXT:     +0x0: 11
; OBJ64-NEXT:     +0x4: 12
; OBJ64-NEXT:     +0x9: 13
; OBJ64-NEXT:     +0xE: 14
; OBJ64-NEXT:     +0x13: 15
; OBJ64-NEXT:     ColStart: 0
; OBJ64-NEXT:     ColEnd: 0
; OBJ64-NEXT:     ColStart: 62
; OBJ64-NEXT:     ColEnd: 62
; OBJ64-NEXT:     ColStart: 63
; OBJ64-NEXT:     ColEnd: 63
; OBJ64-NEXT:     ColStart: 72
; OBJ64-NEXT:     ColEnd: 72
; OBJ64-NEXT:     ColStart: 73
; OBJ64-NEXT:     ColEnd: 73
; OBJ64-NEXT:   ]
; OBJ64-NEXT: ]
; OBJ64:    }

; Function Attrs: nounwind
define void @x() #0 !dbg !4 {
entry:
  call void @z(), !dbg !14
  ret void, !dbg !15
}

declare void @z() #1

; Function Attrs: nounwind
define void @y() #0 !dbg !9 {
entry:
  call void @z(), !dbg !16
  ret void, !dbg !17
}

; Function Attrs: nounwind
define void @f() #0 !dbg !10 {
entry:
  call void @x(), !dbg !18
  call void @y(), !dbg !19
  call void @z(), !dbg !20
  ret void, !dbg !21
}

attributes #0 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-realign-stack" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-realign-stack" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!11, !12}
!llvm.ident = !{!13}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, producer: "clang version 3.5 ", isOptimized: false, emissionKind: 0, file: !1, enums: !2, retainedTypes: !2, subprograms: !3, globals: !2, imports: !2)
!1 = !DIFile(filename: "<unknown>", directory: "D:\5C")
!2 = !{}
!3 = !{!4, !9, !10}
!4 = distinct !DISubprogram(name: "x", line: 3, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, scopeLine: 3, file: !5, scope: !6, type: !7, variables: !2)
!5 = !DIFile(filename: "source.c", directory: "D:\5C")
!6 = !DIFile(filename: "source.c", directory: "D:C")
!7 = !DISubroutineType(types: !8)
!8 = !{null}
!9 = distinct !DISubprogram(name: "y", line: 7, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, scopeLine: 7, file: !5, scope: !6, type: !7, variables: !2)
!10 = distinct !DISubprogram(name: "f", line: 11, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, scopeLine: 11, file: !5, scope: !6, type: !7, variables: !2)
!11 = !{i32 2, !"CodeView", i32 1}
!12 = !{i32 1, !"Debug Info Version", i32 3}
!13 = !{!"clang version 3.5 "}
!14 = !DILocation(line: 4, column: 42, scope: !4)
!15 = !DILocation(line: 5, column: 43, scope: !4)
!16 = !DILocation(line: 8, column: 52, scope: !9)
!17 = !DILocation(line: 9, column: 53, scope: !9)
!18 = !DILocation(line: 12, column: 62, scope: !10)
!19 = !DILocation(line: 13, column: 63, scope: !10)
!20 = !DILocation(line: 14, column: 72, scope: !10)
!21 = !DILocation(line: 15, column: 73, scope: !10)
