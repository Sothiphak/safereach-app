import { Column, CreateDateColumn, Entity, OneToMany, PrimaryGeneratedColumn, UpdateDateColumn } from 'typeorm';

import { PersonalContact } from '../contacts/contact.entity';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id;

  @Column('varchar', { unique: true })
  email;

  @Column('varchar')
  passwordHash;

  @CreateDateColumn()
  createdAt;

  @UpdateDateColumn()
  updatedAt;

  @OneToMany(() => PersonalContact, (contact) => contact.user)
  contacts;
}
