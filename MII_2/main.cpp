#include <stdio.h>
using namespace std;

#include <iostream>

// OpenCV includes
#include <opencv2/opencv.hpp>
using namespace cv;

Mat grayImage;

int threshold_value = 100;
const int max_value = 255;
Mat binarizedImage;

void Threshold(int pos, void* userdata) {
	threshold(grayImage, binarizedImage, threshold_value, max_value, THRESH_BINARY);
	imshow("Binarization", binarizedImage);
}

Mat srcImage;
Mat srcImage2;
Mat weighted;
int alfa = 50;

void diplayWeight(int pos, void* userdata) {
	double a = alfa * 0.01;
	double b = 1 - a;
	addWeighted(srcImage, a, srcImage2, b, 0.0, weighted);
	imshow("Weighted", weighted);
}

void displayWindow(const char* name, int x, int y, Mat img) {
	namedWindow(name);
	moveWindow(name, x, y);
	imshow(name, img);
}

int main()
{
	// reading source file srcImage
	srcImage = imread("Samples/ryba.jpg");
	srcImage2 = imread("Samples/ptak.jpg");
	if (!srcImage.data)
	{
		cout << "Error! Cannot read source file. Press ENTER.";
		waitKey();
		return(-1);
	}
	displayWindow("Damian Jankowski", 0, 0, srcImage);


	cvtColor(srcImage, grayImage, COLOR_BGR2GRAY);
	displayWindow("Gray Image", 300, 0, grayImage);
	imwrite("Samples/Gray image.jpg", grayImage);

	Mat resizedImage(100, 100, srcImage.type());
	resize(srcImage, resizedImage, resizedImage.size());
	displayWindow("Resized image", 600, 0, resizedImage);

	Mat blurImage;
	blur(srcImage, blurImage, Size(5, 5));
	displayWindow("Blur image", 900, 0, blurImage);

	Mat CannyImage;
	Canny(srcImage, CannyImage, 150, 30);
	displayWindow("Canny edges", 1200, 0, CannyImage);

	Mat LaplacianImage;
	Laplacian(srcImage, LaplacianImage, CV_16S, 3);
	Mat scaledLaplacianImage;
	convertScaleAbs(LaplacianImage, scaledLaplacianImage);
	displayWindow("LaplacianImage", 1500, 0, scaledLaplacianImage);

	Mat brightImage;
	srcImage.copyTo(brightImage);

	for (int i = 0; i < brightImage.cols; i++) {
		for (int j = 0; j < brightImage.rows; j++) {
			Vec3b pixelColor;
			pixelColor = brightImage.at<Vec3b>(Point(j, i));
			for (int k = 0; k < 3; k++) {
				if (pixelColor[k] + 100 > 255) pixelColor[k] = 255;
				else pixelColor[k] += 100;
				brightImage.at<Vec3b>(Point(j, i)) = pixelColor;
			}
		}
	}

	displayWindow("Bright Image", 900, 300, brightImage);

	namedWindow("Binarization");
	moveWindow("Binarization", 0, 600);
	createTrackbar("Threshold value", "Binarization", &threshold_value, 255, Threshold);
	Threshold(threshold_value, NULL);

	waitKey();

	namedWindow("Src video");
	moveWindow("Src video", 300, 600);
	namedWindow("Dst video");
	moveWindow("Dst video", 900, 600);

	Mat srcFrame, dstFrame;
	VideoCapture capture("Samples/Dino.avi");
	capture >> srcFrame;
	VideoWriter writer("Samples/Dino2.avi", -1, 25, srcFrame.size());
	while (waitKey(4) != 27 && !srcFrame.empty()) {
		blur(srcFrame, dstFrame, Size(10, 10));
		writer << dstFrame;
		imshow("Src video", srcFrame);
		imshow("Dst video", dstFrame);
		capture >> srcFrame;
	}

	const int histSize = 256;
	const int hist_w = 256;
	const int hist_h = 256;
	float range[2] = { 0, 256 };
	const float* histRange = { range };

	Mat histImageGray(Size(hist_h, hist_w), CV_8UC3, Scalar(0, 0, 0));
	Mat histogramGray;

	calcHist(&grayImage, 1, 0, Mat(), histogramGray, 1, &histSize, &histRange);
	normalize(histogramGray, histogramGray, range[0], range[1], NORM_MINMAX);
	for (int i = 0; i < 256; i++) 
		line(histImageGray, Point(i, hist_h), Point(i, hist_h - cvRound(histogramGray.at<float>(i))), Scalar(255, 0, 0), 2);

	displayWindow("Histogram Gray", 0, 300, histImageGray);

	Mat equalizedHistImage;
	equalizeHist(grayImage, equalizedHistImage);

	displayWindow("Equalized Histogram Image", 300, 300, equalizedHistImage);

	Mat histImageGray2(Size(hist_w, hist_h), CV_8UC3, Scalar(0, 0, 0));
	Mat histogram2;

	calcHist(&equalizedHistImage, 1, 0, Mat(), histogram2, 1, &histSize, &histRange);
	normalize(histogram2, histogram2, range[0], range[1], NORM_MINMAX);

	for (int i = 0; i < 256; i++) 
		line(histImageGray2, Point(i, hist_h), Point(i, hist_h - cvRound(histogram2.at<float>(i))), Scalar(255, 0, 0), 2);

	displayWindow("Histogram Equalized", 600, 300, histImageGray2);

	namedWindow("Weighted");
	moveWindow("Weighted", 1200, 300);
	createTrackbar("Change weight", "Weighted", &alfa, 100, diplayWeight);
	diplayWeight(alfa, NULL);


	waitKey();

	return 0;
}
