import os
import cv2
from datetime import date



def generateCert(name):
    today = str(date.today())
    # print(os.listdir())
    certificate_template_image = cv2.imread("user/new-cert.jpg")
    cv2.putText(certificate_template_image,"Reporting road potholes", (320, 300), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 0), 2,
                cv2.LINE_AA)
    cv2.putText(certificate_template_image, name.strip(), (320, 450), cv2.FONT_HERSHEY_SIMPLEX, 2, (0, 0, 0), 4,
                cv2.LINE_AA)
    cv2.putText(certificate_template_image, name.strip(), (320, 450), cv2.FONT_HERSHEY_SIMPLEX, 2, (0, 0, 0), 4,
                cv2.LINE_AA)
    cv2.putText(certificate_template_image, today, (230, 530), cv2.FONT_HERSHEY_SIMPLEX,0.7, (0, 0, 0), 2,
                cv2.LINE_AA)
    # cv2.imshow('image', certificate_template_image)
    # cv2.waitKey(0)
    # cv2.imshow(certificate_template_image)
    cv2.imwrite("user/cert.jpg".format(name.strip()), certificate_template_image)
    # print("Processing {} / {}".format(index + 1, len(list_of_names)))


