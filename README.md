# ImageAugment
Image augmentation shell script for creating large randomized training sets for image classifiers

requires: python, scikit-image, bash

to use:

download the ImageAugment file.

1. cd to the location of the file in a new terminal prompt.

2. `bash ImageAugment`

3. enter the images directory when prompted. The folder hierachy will be preserved and each new image will be saved in the same image as the original it came from.

4. enter the amount of copies per image desired.

5. enter the x dimensions of the images +- 10%

6. enter the y dimensions of the images +- 10%

7. wait for the process to complete.



built using the image_augmentor repo from @codebox
