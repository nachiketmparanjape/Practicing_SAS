
data test1;
  input a b x1 - x6;
*  input a 3.1 b 3.0 x1 - x6 7.2;
*  input a 1-3 b 5-6 x1 8- 14 x2 16-22 x3 24-30 x4 32-38 x5 40-46 x6 48-54;
*  input a b 5-6 x1 - x6 7.2;
cards;
2.5  0 1424.02 1403.12 1393.00 1288.49 1224.78 1394.01
2.5  5  820.90 1423.01 1541.00 1276.02 1213.83 1253.10
2.5 10  895.34  797.98  705.91  972.38  481.65 1095.32
3.5  0 1722.71 1869.70 1542.69 1570.33 1880.49 1694.39
3.5  5 1775.64 1430.42 1585.84 1349.51 1636.74 1915.88
3.5 10 1161.06 1486.05 1344.12 1528.19 1011.71 1513.69
;
run;

proc print; run;