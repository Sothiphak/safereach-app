import {
  Column,
  CreateDateColumn,
  Entity,
  OneToMany,
  PrimaryColumn,
  UpdateDateColumn,
} from 'typeorm';

import { Review } from '../reviews/review.entity';

@Entity('services')
export class EmergencyService {
  @PrimaryColumn('varchar')
  id;

  @Column('varchar')
  name;

  @Column('varchar')
  type;

  @Column('varchar')
  phone;

  @Column('varchar')
  address;

  @Column('varchar')
  hours;

  @Column('simple-json')
  services;

  @Column('float', { default: 0 })
  rating;

  @Column('int', { default: 0 })
  reviewCount;

  @Column('float', { default: 0 })
  distanceKm;

  @Column('boolean', { default: true })
  openNow;

  @Column('float')
  latitude;

  @Column('float')
  longitude;

  @Column('varchar')
  imageUrl;

  @Column('text')
  description;

  @CreateDateColumn()
  createdAt;

  @UpdateDateColumn()
  updatedAt;

  @OneToMany(() => Review, (review) => review.service)
  reviews;
}
