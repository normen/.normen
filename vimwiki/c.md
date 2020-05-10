## C
```
//to define variables in a nice manner (instead of header)
header:
extern int x;
C:
int x = 0;

left shift	<<	x << y	all bits in x shifted left y bits, multiplies
right shift	>>	x >> y	all bits in x shifted right y bits
bitwise NOT	~	~x	all bits in x flipped
bitwise AND	&	x & y	each bit in x AND each bit in y
bitwise OR	|	x | y	each bit in x OR each bit in y
bitwise XOR	^	x ^ y	each bit in x XOR each bit in y

Basic bit set:
int i = 0 | 1 | 2 | 4 | 8 | 16 | 32 | 64 | 128 //all 8 bits set
bool isSet = 8 & storageVar; //byte at index 3 is set

Setting a bit
number |= 1 << x;

Clearing a bit
number &= ~(1 << x);

Toggling a bit
number ^= 1 << x;

Checking a bit
bit = (number >> x) & 1;

Changing the nth bit to x
number ^= (-x ^ number) & (1 << n);
Bit n will be set if x is 1, and cleared if x is 0.

Combine two bytes:
int combined; 
  combined = x_high;              //send x_high to rightmost 8 bits
  combined = combined<<8;         //shift x_high over to leftmost 8 bits
  combined |= x_low;                 //logical OR keeps x_high intact in combined and fills in                                                             //rightmost 8 bits
  return combined;
```
