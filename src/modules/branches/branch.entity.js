import { Column, CreateDateColumn, Entity, PrimaryColumn, UpdateDateColumn } from 'typeorm';

@Entity('branches')
export class EmergencyBranch {
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

  @Column('float')
  latitude;

  @Column('float')
  longitude;

  @CreateDateColumn()
  createdAt;

  @UpdateDateColumn()
  updatedAt;
}
