xcrun simctl io booted recordVideo preview.mp4 &
P1=$!
(flutter test integration_test && kill -INT $P1) &
P2=$!
wait $P2
