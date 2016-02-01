import numpy as np
import cv2
import sys

if len(sys.argv) < 2:
	print "USAGE: ./capture.py student_name(no spaces please)"
	sys.exit(-1)

student_name = sys.argv[1]
cap = cv2.VideoCapture(0)

counter = 0
while(True):
    # Capture frame-by-frame
    ret, frame = cap.read()
    frame_copy = np.copy(frame)
    # flip horizontally for display (so it is like a mirror)
    frame_copy = cv2.flip(frame_copy, 1)
    # compute lower and upper bounds of the window
    x_lower = int(frame.shape[1]*0.4)
    y_lower = int(frame.shape[0]*0.25)
    x_upper = int(frame.shape[1]*0.6)
    y_upper = int(frame.shape[0]*0.75)

    cv2.rectangle(frame_copy, (x_lower, y_lower),
    						  (x_upper, y_upper),
    						  (0,0,255))
    cv2.imshow('frame',frame_copy)
    key = cv2.waitKey(5)
    print key
    if key & 0xFF == ord(' '):
    	print "SPACE!"
    	pixels = frame[y_lower:y_upper, x_lower:x_upper]
    	cv2.imwrite("faceimage_%s_%02d.png" %(student_name, counter), pixels)
    	counter += 1
    elif key & 0XFF == ord('q'):
        break

# When everything done, release the capture
cap.release()
cv2.destroyAllWindows()
