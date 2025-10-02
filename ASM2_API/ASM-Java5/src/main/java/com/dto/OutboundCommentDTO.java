package com.dto;

import lombok.*;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OutboundCommentDTO implements CommentDTO{
    private Long commentId;
    private Long userId;
    private Long productId;
    private LocalDateTime commentDate;
    private String commentContent;
}