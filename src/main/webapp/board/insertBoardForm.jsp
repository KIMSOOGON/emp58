<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="vo.*"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>insertBoardForm</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body style="background-color:rgb(200,200,205)">
	<div class="container mt-4 p-4 bg-light text-center">
	<form method="post" action="<%=request.getContextPath()%>/board/insertBoardAction.jsp">
		<h2 class="container mt-3 p-3 bg-dark text-warning">게시글 등록</h2>
			<table class="table table-hover">
				<tr>
					<th>제목</th>
					<td><input type="text" name="boardTitle" style="width:400px"></td>
				</tr>
				<tr>
					<th>내용</th>
					<td><textarea name="boardContent" rows="20" cols="50" style="height:300px; width:80%"></textarea></td>
				</tr>
				<tr>
					<th>작성자</th>
					<td><input type="text" name="boardWriter"></td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td><input type="password" name="boardPw"></td>
				</tr>
				<tr>
					<td colspan="2">
						<button class="btn btn-warning text-center" type="submit">등록</button>
					</td>
				</tr>
			</table>
	</form>
	</div>
</body>
</html>