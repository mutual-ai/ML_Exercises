numberOfFiles = 30;

positives = [];
negatives = [];

y = [];
imageFeatures = [];
channel = 1;
for i = 1:numberOfFiles;
   img = imread(sprintf('positives/p%02d.png',i));
   positives = [positives img];

   y = [y 1];
   features = [gradientFeatures(img) colorMeanFeatures(img)];
 %  features = [histogramFeatures(img)];
  
   imageFeatures = [imageFeatures; features];
    
   img2 = imread(sprintf('negatives/n%02d.png',i));

   negatives = [negatives img2];
   features2 = [gradientFeatures(img2) colorMeanFeatures(img2)];
 %  features2 = [histogramFeatures(img2)];

   imageFeatures = [imageFeatures; features2 ];
   y = [y 0];

end

covariance = computeCovariance(imageFeatures, y);

% both class means
mean_0 = mean(imageFeatures(y == 0,:));
mean_1 = mean(imageFeatures(y == 1,:));

display(mean_0)
display(mean_1)

% predict probabilities
F0 = probabilityMultiNormalDistribution(imageFeatures, mean_0, covariance);
F1 = probabilityMultiNormalDistribution(imageFeatures, mean_1, covariance);

% positive or negative example?
classification = F1 > F0;
% check if predictions are correct; 1 is correctly classified, 0 not
correct = 1- abs(classification - y');
display([F0 F1 correct]);

% scattering the gradient features
figure
scatter(imageFeatures(y==0,1), imageFeatures(y == 0,2)); hold on;
scatter(imageFeatures(y==1,1), imageFeatures(y == 1,2)); hold off;
title('Plotting only the gradient features')
xlabel('maximum gradient of image')
ylabel('standard deviation of image gradients')

