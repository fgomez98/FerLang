int main(int argc, char const *argv[]) {
  int i = 1;
  int upper = 500000;
  int j;
  while (i < upper) {
      j = 2;
      while (j <= i/2) {
        if(i % j == 0) {
            break;
         }
        j++;
      }
      i++;
  }
  return 0;
}
