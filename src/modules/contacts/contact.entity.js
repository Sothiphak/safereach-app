import { Column, CreateDateColumn, Entity, ManyToOne, PrimaryGeneratedColumn, UpdateDateColumn } from 'typeorm';
import { User } from '../users/user.entity';

@Entity('personal_contacts')
export class PersonalContact {
  @PrimaryGeneratedColumn('uuid')
  id;

  @Column('varchar')
  name;

  @Column('varchar')
  phone;

  @Column('varchar')
  relationship;

  @ManyToOne(() => User, (user) => user.contacts, { onDelete: 'CASCADE' })
  user;

  @Column('varchar')
  userId;

  @CreateDateColumn()
  createdAt;

  @UpdateDateColumn()
  updatedAt;
}
