<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	String boardNo = request.getParameter("boardNo");
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
	<div class="container mt-4 p-4 bg-light text-center">
		<h2 class="container mt-3 p-3 bg-dark text-warning">※삭제하시겠습니까?※</h2>
		<form method="post" action="<%=request.getContextPath()%>/board/deleteBoardAction.jsp">
			<div>
				<!-- msg 파라메타값이 있으면 출력 -->
			<%
				  if(request.getParameter("msg") != null){
			%>
					<div class="text-center" style="color:red"><%=request.getParameter("msg")%></div>		
			<%		
				  }
			%>
			</div>
			
			<table class="table talbe-hover">
				<tr>
					<!-- <td><mark>No</mark></td> -->
					<td colspan="2"><input type="hidden" name="boardNo" value="<%=boardNo%>" readonly="readonly"></td>
				</tr>
				<tr>
					<td><mark>Password</mark></td>
					<td><input type="password" name="boardPw"></td>
				</tr>
				<tr class="text-center">
					<td colspan="2">
						<button class="btn btn-warning text-center" type="submit">YES</button>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>