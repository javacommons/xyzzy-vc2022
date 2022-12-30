#define LUCIDA_BASE_HEIGHT 128
#define LUCIDA_FACE_NAME "Lucida Sans Unicode"

#define LUCIDA_SPACING 6
struct lucida_spacing {char a; u_char b;};
#define LUCIDA_OFFSET(C) \
  (-lucida_spacing_table[(C)].a - lucida_spacing_table[(C)].b / 2)
#ifdef DEFINE_LUCIDA_OFFSET_TABLE
lucida_spacing lucida_spacing_table[] =
{
  {6,29}, {6,29}, {1,19}, {6,20}, {2,20}, {2,30}, {6,30}, {1,49},
  {1,34}, {6,21}, {6,44}, {10,13}, {10,13}, {10,13}, {9,18}, {7,18},
  {4,26}, {4,26}, {2,33}, {8,33}, {5,33}, {5,33}, {14,36}, {14,36},
  {9,8}, {16,33}, {20,24}, {20,24}, {9,8}, {16,33}, {20,24}, {20,24},
  {10,23}, {10,23}, {6,18}, {6,18}, {7,34}, {7,34}, {8,34}, {8,34},
  {15,34}, {27,10}, {21,23}, {26,18}, {15,34}, {12,40}, {-6,33}, {13,53},
  {0,39}, {6,8}, {6,25}, {6,33}, {3,26}, {2,34}, {2,34}, {2,34},
  {2,34}, {2,34}, {13,53}, {13,53}, {13,53}, {13,53}, {13,53}, {13,53},
  {13,53}, {13,53}, {13,53}, {13,53}, {13,53}, {13,53}, {13,53}, {13,53},
  {13,53}, {13,53}, {13,53}, {13,53}, {13,53}, {13,53}, {13,53}, {13,53},
  {-49,24}, {-40,24}, {-50,36}, {-49,34}, {-47,29}, {-54,54}, {-49,34}, {-37,10},
  {-47,29}, {-37,14}, {-44,23}, {-47,41}, {-50,36}, {-36,8}, {-45,26}, {-54,37},
  {-50,36}, {-49,34}, {-37,10}, {-37,10}, {-37,10}, {-10,10}, {-44,24}, {-45,24},
  {-46,19}, {-35,19}, {-25,25}, {-22,22}, {-39,14}, {-46,27}, {-46,27}, {-46,27},
  {-46,28}, {-24,24}, {-24,24}, {-37,10}, {-47,29}, {-44,23}, {-37,10}, {-36,18},
  {-39,18}, {-36,8}, {-46,28}, {-54,44}, {-50,36}, {-50,36}, {-49,34}, {-49,34},
  {-49,34}, {-49,33}, {-54,54}, {-54,54}, {-54,48}, {-54,48}, {-54,54}, {-54,54},
  {-54,49}, {-38,12}, {-46,28}, {-46,28}, {-54,44}, {-46,27}, {-37,11}, {-54,54},
  {-54,14}, {-24,24}, {13,53}, {13,53}, {-52,40}, {-33,15}, {13,53}, {13,53},
  {13,53}, {13,53}, {13,53}, {13,53}, {13,53}, {13,53}, {13,53}, {13,53},
  {13,53}, {13,53}, {13,53}, {13,53}, {13,53}, {13,53}, {13,53}, {13,53},
  {13,53}, {13,53}, {13,53}, {13,53}, {13,53}, {13,53}, {13,53}, {13,53},
  {13,53}, {13,53}, {13,53}, {13,53}, {13,53}, {13,53}, {13,53}, {13,53},
  {13,53}, {13,53}, {13,53}, {13,53}, {13,53}, {13,53}, {13,53}, {13,53},
};
#else
extern lucida_spacing lucida_spacing_table[];
#endif
