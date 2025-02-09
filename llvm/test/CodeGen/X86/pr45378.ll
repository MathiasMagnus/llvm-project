; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=sse2     | FileCheck %s --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=sse4.1   | FileCheck %s --check-prefix=SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx      | FileCheck %s --check-prefix=AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx2     | FileCheck %s --check-prefix=AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx512f  | FileCheck %s --check-prefix=AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx512bw | FileCheck %s --check-prefix=AVX

declare i64 @llvm.vector.reduce.or.v2i64(<2 x i64>)

define i1 @parseHeaders(i64 * %ptr) nounwind {
; SSE2-LABEL: parseHeaders:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqu (%rdi), %xmm0
; SSE2-NEXT:    pxor %xmm1, %xmm1
; SSE2-NEXT:    pcmpeqd %xmm0, %xmm1
; SSE2-NEXT:    movmskps %xmm1, %eax
; SSE2-NEXT:    xorl $15, %eax
; SSE2-NEXT:    sete %al
; SSE2-NEXT:    retq
;
; SSE41-LABEL: parseHeaders:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movdqu (%rdi), %xmm0
; SSE41-NEXT:    ptest %xmm0, %xmm0
; SSE41-NEXT:    sete %al
; SSE41-NEXT:    retq
;
; AVX-LABEL: parseHeaders:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqu (%rdi), %xmm0
; AVX-NEXT:    vptest %xmm0, %xmm0
; AVX-NEXT:    sete %al
; AVX-NEXT:    retq
  %vptr = bitcast i64 * %ptr to <2 x i64> *
  %vload = load <2 x i64>, <2 x i64> * %vptr, align 8
  %vreduce = call i64 @llvm.vector.reduce.or.v2i64(<2 x i64> %vload)
  %vcheck = icmp eq i64 %vreduce, 0
  ret i1 %vcheck
}

define i1 @parseHeaders2_scalar_or(i64 * %ptr) nounwind {
; SSE2-LABEL: parseHeaders2_scalar_or:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqu (%rdi), %xmm0
; SSE2-NEXT:    pxor %xmm1, %xmm1
; SSE2-NEXT:    pcmpeqd %xmm0, %xmm1
; SSE2-NEXT:    movmskps %xmm1, %eax
; SSE2-NEXT:    xorl $15, %eax
; SSE2-NEXT:    sete %al
; SSE2-NEXT:    retq
;
; SSE41-LABEL: parseHeaders2_scalar_or:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movdqu (%rdi), %xmm0
; SSE41-NEXT:    ptest %xmm0, %xmm0
; SSE41-NEXT:    sete %al
; SSE41-NEXT:    retq
;
; AVX-LABEL: parseHeaders2_scalar_or:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqu (%rdi), %xmm0
; AVX-NEXT:    vptest %xmm0, %xmm0
; AVX-NEXT:    sete %al
; AVX-NEXT:    retq
  %vptr = bitcast i64 * %ptr to <2 x i64> *
  %vload = load <2 x i64>, <2 x i64> * %vptr, align 8
  %v1 = extractelement <2 x i64> %vload, i32 0
  %v2 = extractelement <2 x i64> %vload, i32 1
  %vreduce = or i64 %v1, %v2
  %vcheck = icmp eq i64 %vreduce, 0
  ret i1 %vcheck
}

define i1 @parseHeaders2_scalar_and(i64 * %ptr) nounwind {
; SSE2-LABEL: parseHeaders2_scalar_and:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqu (%rdi), %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[2,3,2,3]
; SSE2-NEXT:    movq %xmm0, %rax
; SSE2-NEXT:    testq %rax, (%rdi)
; SSE2-NEXT:    sete %al
; SSE2-NEXT:    retq
;
; SSE41-LABEL: parseHeaders2_scalar_and:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movq (%rdi), %rax
; SSE41-NEXT:    testq %rax, 8(%rdi)
; SSE41-NEXT:    sete %al
; SSE41-NEXT:    retq
;
; AVX-LABEL: parseHeaders2_scalar_and:
; AVX:       # %bb.0:
; AVX-NEXT:    movq (%rdi), %rax
; AVX-NEXT:    testq %rax, 8(%rdi)
; AVX-NEXT:    sete %al
; AVX-NEXT:    retq
  %vptr = bitcast i64 * %ptr to <2 x i64> *
  %vload = load <2 x i64>, <2 x i64> * %vptr, align 8
  %v1 = extractelement <2 x i64> %vload, i32 0
  %v2 = extractelement <2 x i64> %vload, i32 1
  %vreduce = and i64 %v1, %v2
  %vcheck = icmp eq i64 %vreduce, 0
  ret i1 %vcheck
}
