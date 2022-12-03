#include <opencv2/opencv.hpp>
using namespace cv;

Mat grayImage;

int threshold_value = 100;
const int max_value = 255;
Mat binarizedImage;

void Threshold(int pos, void* userdata) {
	threshold(grayImage, binarizedImage, threshold_value, max_value, THRESH_BINARY);
	imshow("Binarization", binarizedImage);
	return;
};

int main() {

	// reading source file srcImage
	Mat srcImage;
	srcImage = imread("Samples/ryba.jpg");
	if (!srcImage.data)
	{
		std::cout << "Error! Cannot read source file. Press ENTER.";
		waitKey();
		return(-1);
	}
	namedWindow("Damian Jankowski");
	moveWindow("Damian Jankowski", 0, 0);
	imshow("Damian Jankowski", srcImage);

	// Gray Image
	cvtColor(srcImage, grayImage, COLOR_BGR2GRAY);
	namedWindow("Gray Image");
	moveWindow("Gray Image", 300, 0);
	imshow("Gray Image", grayImage);
	imwrite("Samples/Gray Image.jpg", grayImage);

	// Resized image
	Mat resizedImage(100, 100, srcImage.type());
	resize(srcImage, resizedImage, resizedImage.size());
	namedWindow("Resized image");
	moveWindow("Resized image", 600, 0);
	imshow("Resized image", resizedImage);

	// Filtr dolnoprzepustowy
	Mat blurImage;
	blur(srcImage, blurImage, Size(5, 5));
	namedWindow("Blur image");
	moveWindow("Blur image", 900, 0);
	imshow("Blur image", blurImage);

	// Filtr górnoprzepustowy wykrywanie krawêdzi Canny'ego
	Mat CannyImage;
	Canny(srcImage, CannyImage, 90, 90);
	namedWindow("Canny edges");
	moveWindow("Canny edges", 1200, 0);
	imshow("Canny edges", CannyImage);

	// Filtr górnoprzepustowy wykrywanie krawêdzi Laplace'a
	Mat LaplacianImage;
	Laplacian(grayImage, LaplacianImage, CV_16S, 3);
	Mat scaledLaplacianImage;
	convertScaleAbs(LaplacianImage, scaledLaplacianImage);
	namedWindow("Laplacian Image");
	moveWindow("Laplacian Image", 1500, 0);
	imshow("Laplacian Image", scaledLaplacianImage);

	// Rozjasnienie obrazu
	Mat brightImage;
	srcImage.copyTo(brightImage);

	for (int i = 0; i < brightImage.rows; i++) {
		for (int j = 0; j < brightImage.cols; j++) {
			Vec3b pixelColor;
			pixelColor = brightImage.at<Vec3b>(Point(j, i));

			for (int k = 0; k < 3; k++) {
				if (pixelColor[k] + 100 > 255) pixelColor[k] = 255;
				else pixelColor[k] += 100;
				brightImage.at<Vec3b>(Point(j, i)) = pixelColor;
			}
		}
	}

	namedWindow("Bright Image");
	moveWindow("Bright Image", 900, 300);
	imshow("Bright Image", brightImage);

	// Binarized image
	namedWindow("Binarization");
	moveWindow("Binarization", 0, 600);
	createTrackbar("Threshold value", "Binarization", &threshold_value, max_value, Threshold);
	Threshold(threshold_value, NULL);

	waitKey(0);

	// Przetwarzanie wideo
	namedWindow("Src video");
	moveWindow("Src video", 300, 600);
	namedWindow("Dst video");
	moveWindow("Dst video", 900, 600);
	Mat srcFrame, dstFrame;
	VideoCapture capture("Samples/Dino.avi");
	capture >> srcFrame;
	VideoWriter writer("Samples/Dino2.avi", -1, 25, srcFrame.size());
	while (waitKey(4) != 27 && !srcFrame.empty()) {
		Canny(srcFrame, dstFrame, 90, 90);
		writer << dstFrame;
		imshow("Src video", srcFrame);
		imshow("Dst video", dstFrame);
		capture >> srcFrame;
	}

	// Wyliczanie, rysowanie i wyrównanie histogramu
	// a
	const int histSize = 256;
	const int hist_w = 256;
	const int hist_h = 256;
	float range[2] = { 0, 256 };
	const float* histRange = { range };
	Mat histImageGray(Size(hist_h, hist_w), CV_8UC3, Scalar(0, 0, 0));
	Mat histogramGray;
	calcHist(&grayImage, 1, 0, Mat(), histogramGray, 1, &histSize, &histRange);
	normalize(histogramGray, histogramGray, range[0], range[1], NORM_MINMAX);
	for (int i = 0; i < 256; i++) line(histImageGray, Point(i, hist_h), Point(i, hist_h - cvRound(histogramGray.at<float>(i))), Scalar(255, 0, 0), 2);

	namedWindow("Histogram Gray");
	moveWindow("Histogram Gray", 0, 300);
	imshow("Histogram Gray", histImageGray);

	// b
	Mat equalizedHistImage;
	equalizeHist(grayImage, equalizedHistImage);
	namedWindow("Equalized Histogram Image");
	moveWindow("Equalized Histogram Image", 300, 300);
	imshow("Equalized Histogram Image", equalizedHistImage);

	Mat hist2(Size(hist_w, hist_h), CV_8UC3, Scalar(0, 0, 0));
	Mat histogram2;
	calcHist(&equalizedHistImage, 1, 0, Mat(), histogram2, 1, &histSize, &histRange);
	normalize(histogram2, histogram2, range[0], range[1], NORM_MINMAX);
	for (int i = 0; i < 256; i++) line(hist2, Point(i, hist_h), Point(i, hist_h - cvRound(histogram2.at<float>(i))), Scalar(255, 0, 0), 2);

	namedWindow("Histogram Equalized");
	moveWindow("Histogram Equalized", 600, 300);
	imshow("Histogram Equalized", hist2);

	waitKey(0);
	return 0;
}