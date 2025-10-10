package com.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "city", schema = "public")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class City {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "city_id")
    private int cityId;

    @Column(name = "city_name", length = 64)
    private String cityName;
}
