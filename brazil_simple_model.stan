data {
  int<lower=0> N;
  array[N] int<lower=0, upper=6> y;
}

parameters {
  real slope;
  real intercept;
}

model {
  slope ~ normal(0, 1);
  intercept ~ normal(0, 1);
  
  for (i in 1:N) {
    y[i] ~ binomial(6, inv_logit(slope * (i / N) + intercept));
  }
}

generated quantities {
  real theta_predict;
  int<lower=0, upper=6> y_predict;
  theta_predict = inv_logit(slope * ((1.0 + N) / N) + intercept);
  y_predict = binomial_rng(6, theta_predict);
  
  array[N] int<lower=0, upper=6> y_rep;
  for (i in 1:N) {
    real theta = inv_logit(slope * (i / N) + intercept);
    y_rep[i] = binomial_rng(6, theta);
  }
}
