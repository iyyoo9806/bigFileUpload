<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>

<input id="fileUpload" type="file" name="file">
<button onclick="sendVideoChunks()">업로드</button>
<div id="result"></div>

</body>
<script>
    const sendVideoChunks = () => {
        const chunkSize = 1024 * 1024; // 1MB
        const file = document.getElementById("fileUpload").files[0];
        const resultElement = document.getElementById("result");

  		// total size 계산
        const totalChunks = Math.ceil(file.size / chunkSize);
        let currentChunk = 0;

  		// chunk file 전송
        const sendNextChunk = () => {
  			
  			// chunk size 만큼 데이터 분할
            const start = currentChunk * chunkSize;
            const end = Math.min(start + chunkSize, file.size);

            const chunk = file.slice(start, end);
			
  			// form data 형식으로 전송
            const formData = new FormData();
            formData.append("chunk", chunk, file.name);
            formData.append("chunkNumber", currentChunk);
            formData.append("totalChunks", totalChunks);

            fetch("/upload/done", {
                method: "POST",
                body: formData
            }).then(resp => {
  				// 전송 결과가 206이면 다음 파일 조각 전송
                if (resp.status === 206) {
  					// 진행률 표시
                    resultElement.textContent = Math.round(currentChunk / totalChunks * 100) + "%"
                    currentChunk++;
                    if (currentChunk < totalChunks) {
                        sendNextChunk();
                    }
                // 마지막 파일까지 전송 되면 
                } else if (resp.status === 200) {
                    resp.text().then(data => resultElement.textContent = data);
                }
            }).catch(err => {
                console.error("Error uploading video chunk");
            });
        };

        sendNextChunk();
    }
</script>
</html>
