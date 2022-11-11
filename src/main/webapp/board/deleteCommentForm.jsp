<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	// 1. 요청분석
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body style="background-color:rgb(200,200,205)">
	<form method="post" action="<%=request.getContextPath()%>/board/deleteCommentAction.jsp">
	<div class="container mt-4 p-4 bg-light text-center">
		<h2 class="container mt-3 p-3 bg-dark text-warning rounded">※댓글을 삭제하시겠습니까? (패스워드를 입력하시오)※</h2>
		<div>
			<input type="hidden" name="boardNo" value="<%=boardNo%>">
			<input type="hidden" name="commentNo" value="<%=commentNo%>">
		</div>
		<div>
			<%	// 패스워드 입력 안했을 경우
				if(request.getParameter("msg1") != null){
			%>		
					<span><%=request.getParameter("msg1")%></span>
			<%		
				}
			%>
		</div>
		<div>
			<%	// 패스워드 잘못되었을 경우
				if(request.getParameter("msg2") != null){
			%>		
					<span><%=request.getParameter("msg2")%></span>
			<%		
				}
			%>
		</div>
		<div>
			<input type="password" name="commentPw">
		</div>
		<div>
			<button class="btn btn-warning text-center" type="submit">YES</button>
		</div>
	</div>
	</form>
</body>
</html>