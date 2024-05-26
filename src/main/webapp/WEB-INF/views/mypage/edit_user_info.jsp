<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<style>
* {
	margin: 0;
	padding: 0;
}
</style>
<!-- 사용자 정의 자바스크립트 -->
<script>
	/* 데이터 유효성을 확인 해당 데이터 처리하는 메소드 */
	// password 검사 
	function handleCheckData() {
		event.preventDefault();
		
		var el_mempw = document.querySelector("#mempw");
		var el_mempwRe = document.querySelector("#mempwRe");
		var mempwPattern = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,15}$/;
		var mempwResult = mempwPattern.test(el_mempw.value);
		var el_mempw_span = document.querySelector("#mempwSpan");
		var el_mempwRe_span = document.querySelector("#mempwReSpan");

		console.log(mempw.value.length);

		if (el_mempw.value.length === 0) {
			el_mempw_span.innerHTML = '비밀번호를 입력해주세요.';
			el_mempw_span.classList.add("text-danger");
			totalResult = false;
		} else if (el_mempw.value.length <= 7 || !mempwResult) {
			el_mempw_span.innerHTML = '대, 소문자를 포함한 8자이상 15자이하 입력해주세요.';
			el_mempw_span.classList.add("text-danger");
			totalResult = false;
		} else {
			el_mempw_span.innerHTML = '';
			el_mempw_span.classList.remove("text-danger");
		}

		// 비밀번호 확인 검사
		if (el_mempwRe.value.length === 0) {
			el_mempwRe_span.innerHTML = '비밀번호를 입력해주세요.';
			el_mempwRe_span.classList.add("text-danger");
			totalResult = false;
		} else if (el_mempw.value !== el_mempwRe.value) {
			el_mempwRe_span.innerHTML = '비밀번호가 일치하지 않습니다.';
			el_mempwRe_span.classList.add("text-danger");
			totalResult = false;
		} else {
			el_mempwRe_span.innerHTML = '';
			el_mempwRe_span.classList.remove("text-danger");
		} 
		
		// 이름 확인 검사
		var el_memname = document.querySelector('#memname');
		var el_memname_span = document.querySelector("#memnameSpan");
		var memnamePattern = /^[가-힣]{2,4}$/;
		var memnameResult = memnamePattern.test(el_memname.value); 
		
		if (memnameResult) {
			el_memname_span.innerHTML = '';
			el_memname_span.classList.remove("text-danger");
		} else {
			el_memname_span.classList.add("text-danger");
			el_memname_span.innerHTML = '공백 없이 한글, 영문, 숫자만 입력가능(한글 2자, 영문 4자 이상)';
			totalResult = false;
		}
		
		// 닉네임 확인 검사
		var el_memnicknm = document.querySelector("#memnicknm");
		var memnicknmPattern = /^[A-Z][a-zA-Z]{2,7}$/;
		var memnicknmResult = memnicknmPattern.test(el_memnicknm.value);
		var el_memnicknm_span = document.querySelector("#memnicknmSpan");
		
		if(memnicknmResult){
			el_memnicknm_span.innerHTML = '';
			el_memnicknm_span.classList.remove("text-danger");
		} else {
			el_memnicknm_span.innerHTML = '닉네임 첫 글자는 대문자로 3자이상 8자 이하로 작성해주세요.'
			el_memnicknm_span.classList.add("text-danger");
			totalResult = false;
		}
		
		// 이메일 확인 검사
		var el_mememail = document.querySelector("#mememail");
		var mememailPattern = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-za-z0-9\-]+/;
		var mememailResult = mememailPattern.test(el_mememail.value);
		var el_mememail_span = document.querySelector("#mememailSpan");
		
		if(mememailResult){
			el_mememail_span.innerHTML = '';
			el_mememail_span.classList.remove("text-danger");
		} else {
			el_mememail_span.innerHTML = '이메일 형식에 맞게 입력해주세요.';
			el_mememail_span.classList.add("text-danger");
			totalResult = false;
		}
		
		// 휴대폰 번호 확인 검사
		var el_memtel = document.querySelector("#memtel");
		var memtelPattern = /^(01[016789]{1})-?[0-9]{3,4}-?[0-9]{4}$/;
		var memtelResult = memtelPattern.test(el_memtel.value);
		var el_memtel_span = document.querySelector("#memtelSpan");
		
		if(memtelResult){
			el_memtel_span.innerHTML = '';
			el_memtel_span.classList.remove("text-danger");
		} else {
			el_memtel_span.innerHTML = '휴대폰 번호를 입력해 주세요.';
			el_memtel_span.classList.add("text-danger");
			totalResult = false;
		}
		
	}
</script>
<script>
//주소검색 api
function execDaumPostcode() {
	new daum.Postcode({
		oncomplete : function(data) {
			// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

			// 각 주소의 노출 규칙에 따라 주소를 조합한다.
			// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
			var addr = ''; // 주소 변수
			var extraAddr = ''; // 참고항목 변수

			//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
			if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
				addr = data.roadAddress;
			} else { // 사용자가 지번 주소를 선택했을 경우(J)
				addr = data.jibunAddress;
			}

			// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
			if (data.userSelectedType === 'R') {
				// 법정동명이 있을 경우 추가한다. (법정리는 제외)
				// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
				if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
					extraAddr += data.bname;
				}
				// 건물명이 있고, 공동주택일 경우 추가한다.
				if (data.buildingName !== '' && data.apartment === 'Y') {
					extraAddr += (extraAddr !== '' ? ', '
							+ data.buildingName : data.buildingName);
				}
				// 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
				if (extraAddr !== '') {
					extraAddr = ' (' + extraAddr + ')';
				}
				// 조합된 참고항목을 해당 필드에 넣는다.
				document.getElementById("adrsearch").value = extraAddr;

			} else {
				document.getElementById("adrsearch").value = '';
			}

			// 우편번호와 주소 정보를 해당 필드에 넣는다.
			document.getElementById('postno').value = data.zonecode;
			document.getElementById("adr").value = addr;
			// 커서를 상세주소 필드로 이동한다.
			document.getElementById("adrdtl").focus();
		}
	}).open();
}
</script>


<!-- jQuery 외부 라이브러리 설정 -->
<script
	src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- Latest compiled and minified CSS -->
<!-- 클라이언트에게 라이브러리 파일을 어디 서버에 다운받을 지 배정받는다. -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<meta charset="UTF-8">
<title>회원가입</title>
</head>
<body>
	<!-- header -->
	<%@ include file="/WEB-INF/views/common/header.jsp"%>


	<div class="container-fluid d-flex justify-content-center">

		<form id="joinForm" name="joinForm"
			action="${pageContext.request.contextPath}/mypage/update_user_info"
			method="post" novalidate style="width: 400px;" class="d-flex flex-column"
			enctype="multipart/form-data" onsubmit="handleCheckData()">
			
			<input type="hidden" class="form-control w-100" id="memno"
				name="memno" value="${member.memno}" readonly>

			<!-- handleCheckData()를 사용하여 사용자 정의 유효성 검사를 수행함, novalidate속성을 사용하여 기본 브라우저의  유효성 검사를 막음 -->
			<div class="container-fluid d-flex justify-content-center p-5 m-3">
				<h2>사용자 정보 수정</h2>
			</div>
			<div class="mb-3">
				<h5>사이트 이용정보</h5>
			</div>
			<label for="memid">아이디</label> <input type="text"
				class="form-control w-100" id="memid" name="memid"
				value="${member.memid}" readonly>
			<div class="my-2 ms-2"></div>
			<div class="my-2">
				<label for="mempw">비밀번호 변경</label> <input type="password"
					class="form-control w-100" id="mempw" name="mempw"
					placeholder="새 비밀번호 입력(필수)">
				<div class="mx-2 mt-2">
					<span id="mempwSpan" class="form-text" style="font-size: 11px;">대,
						소문자를 포함한 8자이상 15자이하 입력해주세요.</span>
				</div>
			</div>
			<input type="password" class="form-control w-100" id="mempwRe"
				placeholder="비밀번호확인 (필수)">
			<div class="mx-2 mt-2">
				<span id="mempwReSpan" class="form-text" style="font-size: 11px;">비밀번호가
					일치하지 않습니다.</span>
			</div>

			<div class="mt-2">
				<span>이미지 변경</span>
			</div>

			<div class="border p-3 d-flex flex-column align-items-center">
				<img class="img-fluid rounded-circle"
					src="${pageContext.request.contextPath}/mypage/downloadMemImg?memno=${member.memno}"
					width="100px">
				<div class="d-flex flex-column mt-3">
					<input type="file" class="form-control" name="memimgattach">
				</div>
			</div>

			<div class="pt-5">
				<h5>개인정보</h5>
			</div>
			<input type="text" class="form-control w-100" id="memname"
				placeholder="이름 (필수)" name="memname" value="${member.memname}"
				required>
			<div class="p-2">
				<span id="memnameSpan" class="form-text" style="font-size: 11px;">공백없이
					한글,영문,숫자만 입력가능(한글2자, 영문 4자 이상)</span>
			</div>
			<div class="mb-3 my-2">
				<input type="text" class="form-control w-100" id="memnicknm"
					placeholder="닉네임 (필수)" name="memnicknm" value="${member.memnicknm}"
					required>
				<div class="mx-2 mt-2">
					<span id="memnicknmSpan" class="form-text" style="font-size: 11px;">닉네임
						첫 글자는 대문자로 시작하며 3자이상 8자이하로 작성해주세요.</span>
				</div>
			</div>
			<div class="mb-3">
				<input type="email" class="form-control w-100" id="mememail"
					placeholder="Email (필수)" name="mememail" value="${member.mememail}"
					required>
				<div class="mx-2 mt-2">
					<span id="mememailSpan" class="form-text" style="font-size: 11px;">이메일
						형식에 맞춰 입력해주세요.</span>
				</div>
			</div>

			<input type="text" class="form-control w-100" id="memtel"
				placeholder="휴대폰번호 (필수)" name="memtel" value="${member.memtel}"
				required>
			<div class="mx-2">
				<span id="memtelSpan" class="form-text" style="font-size: 11px;">휴대폰
					번호를 입력해주세요.</span>
			</div>
			<div class="w-100 d-flex justify-content-end mt-3 mb-3">
				<button type="button" class="btn text-white btn-sm"
					style="background-color: #9523DC;" onclick="execDaumPostcode()" id="adrsearch" name="adrsearch">주소검색</button>
			</div>
			<div class="mb-3">
				<input type="text" class="form-control w-100" id="postno"
					placeholder="우편번호 (필수)" name="postno" value="${memberAdr.postno}"
					required>
				<div class="mx-2">
					<span id="upostalCodeSpan" class="form-text"
						style="font-size: 11px;">우편번호 입력해 주세요.</span>
				</div>
			</div>

			<div class="mb-3">
				<input type="text" class="form-control w-100" id="adr"
					placeholder="주소 (필수)" name="adr" value="${memberAdr.adr}" required>
				<div class="mx-2">
					<span id="adre" class="form-text" style="font-size: 11px;">주소를
						입력해주세요.</span>
				</div>
			</div>

			<input type="text" class="form-control w-100" id="adrdtl"
				placeholder="상세주소" name="adrdtl" value="${memberAdr.adrdtl}">

			<div class="w-100 d-flex justify-content-center p-5">
				<input type="submit" class="btn text-white btn-sm w-100"
					style="background-color: #9523DC;" value="회원정보수정" />
			</div>
		</form>
		<script
			src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	</div>
	<div style="height:100px"></div>

	<!-- footer -->
	<%@ include file="/WEB-INF/views/common/footer.jsp"%>
</body>
</html>