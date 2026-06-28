import {
  Column,
  CreateDateColumn,
  Entity,
  ManyToOne,
  PrimaryColumn,
  UpdateDateColumn,
} from 'typeorm';
import { EmergencyService } from '../services/service.entity';

@Entity('reviews')
export class Review {
  @PrimaryColumn('varchar')
  id;

  @Column('varchar')
  serviceId;

  @Column('varchar')
  author;

  @Column('float')
  rating;

  @Column('varchar')
  date;

  @Column('text')
  comment;

  @ManyToOne(() => EmergencyService, (service) => service.reviews, {
    onDelete: 'CASCADE',
  })
  service;

  @CreateDateColumn()
  createdAt;

  @UpdateDateColumn()
  updatedAt;
}
