data {
  int<lower=0> N;
  array[N] int<lower=0, upper=6> y;
}

parameters {
  real slope;
  real intercept;
  real<lower=0> kappa;
}

model {
  slope ~ normal(0, 1);
  intercept ~ normal(0, 1);
  kappa ~ normal(0, 2);

  for (i in 1:N) {
    real mu = inv_logit(slope * (i / N) + intercept);
    real alpha = mu * kappa;
    real beta = (1 - mu) * kappa;
    y[i] ~ beta_binomial(6, alpha, beta);
  }
}

generated quantities {
  int<lower=0, upper=6> y_predict;
  real mu_pred = inv_logit(slope * ((1.0 + N) / N) + intercept);
  real alpha_pred = mu_pred * kappa;
  real beta_pred = (1 - mu_pred) * kappa;
  
  y_predict = beta_binomial_rng(6, alpha_pred, beta_pred);
  
  array[N] int<lower=0, upper=6> y_rep;
  for (i in 1:N) {
    real mu_rep = inv_logit(slope * (i / N) + intercept);
    real alpha_rep = mu_rep * kappa;
    real beta_rep = (1 - mu_rep) * kappa;
    
    y_rep[i] = beta_binomial_rng(6, alpha_rep, beta_rep);
  }
}
