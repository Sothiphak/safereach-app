import {
  Column,
  CreateDateColumn,
  Entity,
  PrimaryColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('tips')
export class Tip {
  @PrimaryColumn('varchar')
  id;

  @Column('varchar')
  title;

  @Column('varchar')
  summary;

  @Column('varchar')
  imageAsset;

  @Column('simple-json')
  steps;

  @CreateDateColumn()
  createdAt;

  @UpdateDateColumn()
  updatedAt;
}
