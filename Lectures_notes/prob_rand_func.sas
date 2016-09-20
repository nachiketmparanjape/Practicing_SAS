
data temp1;
  x = 3;
  p_success = 0.3;
  n1 = 12;
  n2 = 6;
  m = 4;
  alpha = 2.5;
  beta = 1;
  df1 = 6; 
  df2 = 12;

  p_bin1 = probbnml(p_success, n1, x);
  p_bin2 = probbnml(p_success, n1, x) - probbnml(p_success, n1, x-1);
  p_bin3 = pdf('BINOMIAL', x, p_success, n1);
  p_hyp = probhypr(n1, n2, m, x);
  p_negb = probnegb(p_success, n1, x);
  p_beta = probbeta(p_success, alpha, beta);
  p_chi = probchi(x, df1);
  p_f1 = probf(x, df1, df2);
  p_f2 = sdf('F', x, df1, df2);
  p_gamma = probgam(x, alpha);
  p_norm = probnorm(x);
  p_norm2 = pdf('NORMAL', x);
  p_t1 = probt(x, df1);
  p_t2 = probt(x, df1, beta);
  p_weib = cdf('WEIBULL',alpha, beta);
  p_mc = probmc('anom', beta, ., df2, m);
  output;
run;

proc print data=temp1; run;

data temp2;
  p = 0.95;
  alpha = 2.5;
  beta = 1;
  df1 = 6; 
  df2 = 12;

  x_beta = betainv(p, alpha, beta);
  x_chi1 = cinv(p, df1);
  x_chi2 = quantile('CHISQUARE', p, df1);
  x_chi3 = squantile('CHISQUARE', p, df1);
  x_gam = gaminv(p, alpha);
  x_f = finv(p,df1, df2);
  x_t = tinv(p, df1);
  x_n = probit(p);
  x_mc = probmc('anom', ., 1-p, df2, 4);

  output;
run;

proc print data=temp2; run;

data temp3;
  seed = 489573124;

  do i = 1 to 12;
    x_bin = ranbin(seed, 10, 0.7);
    x_poi = ranpoi(seed, 10);

    x_cau = rancau(seed);
    x_exp = ranexp(seed);
    x_gam = rangam(seed, 2.4);
    x_nrm1 = rannor(seed);
	x_nrm2 = rand('NORMAL', 10, 2);
	x_lnrm = rand('LOGNORMAL'); 
    x_tri = rantri(seed, 0.6);
    x_uni = ranuni(seed);

    x_hyp = rand('HYPER', 10, 5, 1);
    output;
  end;
run;

proc print data=temp3; run;

data temp4; set temp3;
  mean1 = mean(x_cau, x_exp, x_gam, x_nrm1, x_tri, x_uni);
  median1 = median(x_cau, x_exp, x_gam, x_nrm1, x_tri, x_uni);
  var1 = var(x_cau, x_exp, x_gam, x_nrm1, x_tri, x_uni);
  range1 = range(x_cau, x_exp, x_gam, x_nrm1, x_tri, x_uni);
  iqr1 = iqr(x_cau, x_exp, x_gam, x_nrm1, x_tri, x_uni);
  k1 = kurtosis(x_cau, x_exp, x_gam, x_nrm1, x_tri, x_uni);
  ord2 = ordinal(2, x_cau, x_exp, x_gam, x_nrm1, x_tri, x_uni);
run;

proc print data=temp4; run;

 
