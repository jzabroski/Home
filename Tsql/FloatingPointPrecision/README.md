[How It Works: SQL Parsing of Number(s), Numeric and Float Conversions](https://techcommunity.microsoft.com/t5/sql-server-support/how-it-works-sql-parsing-of-number-s-numeric-and-float/ba-p/316234)
by Bob Dorr

> Thinking about this more it becomes clear that the exponent can only represent approximately (2 ^ 11th = ~2048) exact values if you leave the mantissa all zeros.
> (There are special cases for NaN and Infinite states).   With a all zero mantissa the mathematics will be Exponent * 1.0 for an exact match.
> Anything outside of 1.0 for the mantissa has the possibility to vary from a strict integer, whole value.

[There Are Only 4 Billion Floats - So Test Them All](https://news.ycombinator.com/item?id=7135261) viz a viz [Bruce Dawson's randomascii.wordpress.com blog](https://randomascii.wordpress.com/2014/01/27/theres-only-four-billion-floatsso-test-them-all/)

> ```c
>  float old_mm_ceil_ps2(float f)
> {
>     __m128 input = { f, 0, 0, 0 };
>     __m128 result = old_mm_ceil_ps2(input);
>     return result.m128_f32[0];
> }
> 
> int main()
> {
>     // This is the biggest number that can be represented in
>     // both float and int32_t. It’s 2^31-128.
>     Float_t maxfloatasint(2147483520.0f);
>     const uint32_t signBit = 0×80000000;
>     ExhaustiveTest(0, (uint32_t)maxfloatasint.i, old_mm_ceil_ps2, ceil,
>                 "old _mm_ceil_ps2");
>     ExhaustiveTest(signBit, signBit | maxfloatasint.i, old_mm_ceil_ps2, ceil,
>                 "old _mm_ceil_ps2");
> }
> ```
