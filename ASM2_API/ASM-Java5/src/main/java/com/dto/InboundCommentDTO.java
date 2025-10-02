package com.dto;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class InboundCommentDTO implements CommentDTO{
    private Long userId;
    private Long productId;
    private String commentContent;
}
